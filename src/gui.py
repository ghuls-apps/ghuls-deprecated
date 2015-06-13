import Tkinter
import tkMessageBox

def auth_with_un():
    top.wm_title("Login with Username and Password")
    loginbutton.pack_forget()
    authbutton.pack_forget()
    usernametext = Tkinter.Entry(top)
    passwordtext = Tkinter.Entry(top, show="*")
    userpassbutton = Tkinter.Button(top, text = "Login")
    usernametext.insert(0, "Username")
    passwordtext.insert(0, "Password")
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
