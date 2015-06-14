import Tkinter
import tkMessageBox
from pylab import figure, pie, show
import subprocess
import json

def graph(user, text, button):
    jsonfile = open("tmp/" + user + ".json", 'r')
    # decoded_response = jsonfile.read().decode("UTF-8")
    jsonresponse = json.load(jsonfile)
    data = jsonresponse["langs"]
    langs = []
    bytes = []
    for item in data:
        lang = # something
        langs.append(lang)
        byte = # something
        bytes.append(byte)
    pie(bytes, labels=langs)
    text.pack_forget()
    button.pack_forget()
    show()
    jsonfile.close()

def run_perl(ut, pt, an, anb):
    f = open("info.txt", 'w+')
    f.write(ut.get() + "\n" + pt.get() + "\n" + an.get())
    f.close()
    subprocess.Popen(["perl", "index.pl"], stdout=subprocess.PIPE).wait();
    graph(an.get(), an, anb)

def login_with_un(ut, pt, upb):
    top.wm_title("Choose GitHub user to analyze")
    ut.pack_forget()
    pt.pack_forget()
    upb.pack_forget()
    analyzetext = Tkinter.Entry(top)
    analyzebutton = Tkinter.Button(top, text = "Analyze", command = lambda: run_perl(ut, pt, analyzetext, analyzebutton))
    analyzetext.pack()
    analyzebutton.pack()

def login_with_code():
    tkMessageBox.showinfo("using code", "weee")

def auth_with_un():
    top.wm_title("Login with Username and Password")
    loginbutton.pack_forget()
    authbutton.pack_forget()
    usernametext = Tkinter.Entry(top)
    passwordtext = Tkinter.Entry(top, show="*")
    userpassbutton = Tkinter.Button(top, text = "Login", command = lambda: login_with_un(usernametext, passwordtext, userpassbutton))
    usernametext.grid(row=0)
    passwordtext.grid(row=1)
    usernametext.pack()
    passwordtext.pack()
    userpassbutton.pack()

def auth_with_code():
    tkMessageBox.showinfo("using code", "weee")

top = Tkinter.Tk()
top.wm_title("Pick Authorization Method")
top.minsize(width = 666, height = 666)
choosetext = Tkinter.Canvas(top, width = 200, height = 100)
loginbutton = Tkinter.Button(top, text = "Login", command = auth_with_un)
authbutton = Tkinter.Button(top, text = "Auth Code", command = auth_with_code)

loginbutton.pack()
authbutton.pack()
top.mainloop()
