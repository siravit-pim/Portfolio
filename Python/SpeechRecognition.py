# AI Personal Assistant
# Speech Recognition
# pip install SpeechRecognition
import speech_recognition as sr
# pip install PyAudio
import pyttsx3
import webbrowser
import datetime
import time

def greeting():
    hour = datetime.datetime.now().hour
    if hour >= 0 and hour < 12:
        speak("Hello Good moring")
        print("Hello Good moring")
    elif hour >= 12 and hour < 15:
        speak("Hello Good afternoon")
        print("Hello Good afternoon")
    else:
        speak("Hello Good evening")
        print("Hello Good evening")

def speak(text):
    engine.say(text)
    engine.runAndWait()

def takeCommand():
    with sr.Microphone() as source:
        recognizerObject.adjust_for_ambient_noise(source)
        print("Listening...")
        voice = recognizerObject.listen(source, timeout = 5)
        try:
            statement = recognizerObject.recognize_google(voice)
            print("Got it")
            print("User said:"+ statement)
        except Exception as e:
            print("Pardon me, please say it again")
            speak("Pardon me, please say it again")
            return "None"
        return statement

recognizerObject = sr.Recognizer()
engine = pyttsx3.init()

print("Loading your AI Personal Assistant - Javis")
speak("Loading your AI Personal Assistant - Javis")

greeting()

while True:
    print("I'm ready to servivce. How can i help you?")
    speak("I'm ready to servivce. How can i help you?")

    statement = takeCommand().lower()

    if statement == "None":
        continue
    if "good bye" in statement or "stop" in statement or "bye" in statement:
        print("your AI Personal assistant Javis is shutting down, good bye")
        speak("your AI Personal assistant Javis is shutting down, good bye")
        break
    if "youtube" in statement:
        webbrowser.open_new_tap("https://www.youtube.com")
        print("Youtube is open now")
        speak("Youtube is open now")
    elif "google" in statement:
        webbrowser.open_new_tap("https://www.google.com")
        print("Google is open now")
        speak("Google is open now")
    elif "time" in statement:
        strTime = datetime.datetime.now().strtime("%H:%M:%S")
        print("The time is"+strTime)
        speak("The time is"+strTime)
    elif "how are you" in statement:
        print("I'm not bad. Thanks")
        speak("I'm not bad. Thanks")
