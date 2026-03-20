import os
from pathlib import Path
from docling.document_converter import DocumentConverter, PdfFormatOption
from docling.datamodel.pipeline_options import PdfPipelineOptions
from docling.datamodel.base_models import InputFormat

def convert_files():
    # Definição das conversões solicitadas
    tasks = [
        {
            "description": "Relatórios",
            "input": Path(r"c:\Users\pedro\Downloads\Curriculos.com\docs\relatorios\raw"),
            "output": Path(r"c:\Users\pedro\Downloads\Curriculos.com\docs\relatorios")
        },
        {
            "description": "Apresentação Disciplina",
            "input": Path(r"c:\Users\pedro\Downloads\Curriculos.com\docs\apresentacao_diciplina"),
            "output": Path(r"c:\Users\pedro\Downloads\Curriculos.com\docs\apresentacao_diciplina")
        }
    ]
    
    # Configurações para evitar erro de memória (std::bad_alloc)
    pipeline_options = PdfPipelineOptions()
    # Em vez de num_threads, o Docling V2 (atual) utiliza configurações de batch:
    pipeline_options.ocr_batch_size = 1
    pipeline_options.layout_batch_size = 1
    pipeline_options.table_batch_size = 1
    # Caso necessário, você pode ignorar o OCR de imagens se forem PDFs apenas de texto:
    # pipeline_options.do_ocr = False
    
    converter = DocumentConverter(
        format_options={
            InputFormat.PDF: PdfFormatOption(pipeline_options=pipeline_options)
        }
    )
    supported_extensions = {'.pdf', '.docx', '.pptx', '.html', '.md'}
    
    for task in tasks:
        input_dir = task["input"]
        output_dir = task["output"]
        desc = task["description"]
        
        if not input_dir.exists():
            print(f"Diretório não encontrado para {desc}: {input_dir}")
            continue
            
        print(f"--- Iniciando {desc} em: {input_dir} ---")
        output_dir.mkdir(parents=True, exist_ok=True)
        
        files_count = 0
        for file_path in input_dir.iterdir():
            if file_path.is_file() and file_path.suffix.lower() in supported_extensions:
                files_count += 1
                try:
                    print(f"Convertendo: {file_path.name}...")
                    result = converter.convert(str(file_path))
                    output_file = output_dir / f"{file_path.stem}.md"
                    
                    markdown_content = result.document.export_to_markdown()
                    output_file.write_text(markdown_content, encoding="utf-8")
                    
                    print(f"Salvo: {output_file.name}")
                except Exception as e:
                    print(f"Erro ao converter {file_path.name}: {e}")
        
        print(f"Concluído {desc}: {files_count} arquivos.\n")


if __name__ == "__main__":
    # Nota: Certifique-se de ter o docling instalado: pip install docling
    convert_files()