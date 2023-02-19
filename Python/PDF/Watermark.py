## Watermark
# pip install PyPDF4
import PyPDF4

def watermarkMaking(originalFileName, outputFileName, watermarkFileName):
    pdfReader = PyPDF4.PdfFileReader(originalFileName)
    watermarkReader = PyPDF4.PdfFileReader(watermarkFileName)
    mergePDF = PyPDF4.PdfFileWriter()

    watermark = watermarkReader.getPage(0)

    for page in range(pdfReader.getNumPages()):
        currentPage = pdfReader.getPage(page)
        currentPage.mergePage(watermark)

        mergePDF.addPage(currentPage)

    newFile = open(outputFileName, 'wb')
    mergePDF.write(newFile)
    newFile.close()
    print("Done !")

# defind original file, output file and watermark file
originalFileName = "test_PDF1.pdf"
outputFileName = "watermark.pdf"
watermarkFileName = "test_PDF2.pdf"

watermarkMaking(originalFileName, outputFileName, watermarkFileName)
