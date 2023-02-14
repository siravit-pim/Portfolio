## Youtube to .MP4
#pip install pytube
from pytube import YouTube

def youtubeDownloader(link):
    youtubeObject = YouTube(link)
    youtubeObject = youtubeObject.streams.get_highest_resolution() #max quality
    try:
        youtubeObject.download()
        print("Done !")
    except:
        print("Some Error Occurred")

link = input("Enter Youtube Link : ")

youtubeDownloader(link)
# -----------------------------------------------------
