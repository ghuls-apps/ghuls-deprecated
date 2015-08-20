import Tkinter
import tkMessageBox
from pylab import figure, pie, show, title
import subprocess
import json
import os

def graph(user, text, button):
    jsonfilename = "tmp/" + user + ".json";
    jsonfile = open(jsonfilename, 'r')
    # decoded_response = jsonfile.read().decode("UTF-8")
    jsonresponse = json.load(jsonfile)
    data = jsonresponse["langs"]
    langs = []
    bytes = []
    num_langs = 0
    for lang, byte in data.items():
        langs.append(lang)
        bytes.append(byte)
        num_langs += 1
    pie(bytes, labels=langs)
    text.pack_forget()
    button.pack_forget()
    show()
    title(user + '\'s Language Statistics')
    jsonfile.close()
    os.remove(jsonfilename);

def run_perl_with_login(usertext, passtext, analyzetext, analyzebutton):
    f = open("info.txt", 'w+')
    f.write(usertext.get() + "\n" + passtext.get() + "\n" + analyzetext.get())
    f.close()
    subprocess.Popen(["perl", "index.pl"], stdout=subprocess.PIPE).wait()
    graph(analyzetext.get(), analyzetext, analyzebutton)

def run_perl_with_code(authtext, user, button):
    f = open("info.txt", 'w+')
    f.write(auth.get() + "\n" + user.get())
    f.close()
    subprocess.Popen(["perl", "index.pl"], stdout=subprocess.PIPE).wait()
    graph(user.get(), authtext, button)

def analyze_with_un(usertext, passwordtext, userpassbutton):
    top.wm_title("Choose GitHub user to analyze")
    usertext.pack_forget()
    passwordtext.pack_forget()
    userpassbutton.pack_forget()
    analyzetext = Tkinter.Entry(top)
    analyzebutton = Tkinter.Button(top, text = "Analyze", command = lambda: run_perl_with_login(usertext, passwordtext, analyzetext, analyzebutton))
    analyzetext.pack()
    analyzebutton.pack()

def analyze_with_code(authtext, authbutton):
    top.wm_title("Choose GitHub user to analyze")
    authtext.pack_forget()
    authbutton.pack_forget()
    analyzetext = Tkinter.Entry(top)
    analyzebutton = Tkinter.Button(top, text = "Analyze", command = lambda: run_perl_with_code(authtext, analyzetext, analyzebutton))
    analyzetext.pack()
    analyzebutton.pack()

def auth_with_un():
    top.wm_title("Login with Username and Password")
    loginbutton.pack_forget()
    authbutton.pack_forget()
    usernametext = Tkinter.Entry(top)
    passwordtext = Tkinter.Entry(top, show="*")
    userpassbutton = Tkinter.Button(top, text = "Login", command = lambda: analyze_with_un(usernametext, passwordtext, userpassbutton))
    usernametext.grid(row=0)
    passwordtext.grid(row=1)
    usernametext.pack()
    passwordtext.pack()
    userpassbutton.pack()

def auth_with_code():
    top.wm_title("Login with Authorization Code")
    loginbutton.pack_forget()
    authbutton.pack_forget()
    authcodetext = Tkinter.Entry(top, show="*")
    authcodebutton = Tkinter.Button(top, text = "Authorize", command = lambda: analyze_with_code(authcodetext, authcodebutton))
    authcodetext.pack()
    authcodebutton.pack()

top = Tkinter.Tk()
top.wm_title("Pick Authorization Method")
top.minsize(width = 666, height = 666)
choosetext = Tkinter.Canvas(top, width = 200, height = 100)
loginbutton = Tkinter.Button(top, text = "Login", command = auth_with_un)
authbutton = Tkinter.Button(top, text = "Auth Code", command = auth_with_code)

loginbutton.pack()
authbutton.pack()
top.mainloop()
