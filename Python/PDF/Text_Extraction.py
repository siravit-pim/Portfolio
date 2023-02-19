## Text Extraction
# pip install PyPDF4
import PyPDF4

pdfFileName = "splittedFile_1.pdf"

pdfReader = PyPDF4.PdfFileReader(pdfFileName)
for page in pdfReader.pages:
    print(page.extractText())
    
#pageObject = pdfReader.getPage(0)
#extractedText = pageObject.extractText()
#print(extractedText)
