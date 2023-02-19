## PDF File Splitting
# pip install PyPDF4
import PyPDF4

def PDFSplitting(originalFileName, splitPosition):
    start = startPage
    end = splitPosition[0]

    for i in range(len(splitPosition)+1):
        pdfReader = PyPDF4.PdfFileReader(originalFileName)
        pdfWriter = PyPDF4.PdfFileWriter()

        for page in range(start, end):
            pdfWriter.addPage(pdfReader.getPage(page))
    
        outputpdf = "splittedFile_"+str(i+1)+".pdf"
        newFile = open(outputpdf, 'wb')

        pdfWriter.write(newFile)
        newFile.close()
        start = end

        try:
            end = splitPosition[i+1]
        except IndexError:
            end = pdfReader.getNumPages()
        print("Done !")

# defind original file and number to split
originalFileName = 'book1.pdf'
splitPosition = [10] #page end
startPage = 4

PDFSplitting(originalFileName, splitPosition)
