## can make Audio Book
#pip install PyPDF4
import PyPDF4
#pip install pyttsx3
import pyttsx3

engine = pyttsx3.init()

voices = engine.getProperty("voices")
engine.setProperty("rate", 150) # speed
engine.setProperty("volume", 1.0)
engine.setProperty("voice", voices[0].id) # think UK

to_read_file = "audioPDF.pdf"
pdfReader = PyPDF4.PdfFileReader(to_read_file)

for page in range(pdfReader.getNumPages()):
    text = pdfReader.getPage(page).extractText()
    engine.say(text)
    engine.runAndWait()
engine.stop()

engine.save_to_file(text, "test_audio.mp3")
engine.runAndWait()
print("Done !") # if error / pip install -U pyobjc
