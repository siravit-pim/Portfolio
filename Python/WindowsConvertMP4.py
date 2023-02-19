#pip install pytube
from pytube import YouTube
import tkinter as tk #python3
from tkinter import *

root = tk.Tk()

# title windows
root.title('Youtube Convert to MP4')

# setting window size
#root.geometry('250x100')

# label (text)
l1 = Label(root, text="Youtube Link Input: ").grid(row=1)

# create entry for get link
e1 = tk.Entry()
e1.grid(row=2)

# label result
result = Label(root, text='')
result.grid(row=3)

# --------------------------------
def youtubeDownloader():
    link = e1.get()
    youtubeObject = YouTube(link)
    youtubeObject = youtubeObject.streams.get_highest_resolution() #max quality
    print("Processing !  Please wait.")
    try:
        youtubeObject.download()
        result.config(text="Task Complated !")
        print("Done !")
    except:
        print("Some Error Occurred")
    
# create button
button = tk.Button(root, text='Convert to MP4',command=youtubeDownloader).grid(row=4)

root.mainloop()
