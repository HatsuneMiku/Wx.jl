#!/usr/local/bin/julia
# -*- coding: utf-8 -*-

# \julia-0.4.3\bin\julia --precompiled=yes test_tk.jl # この方が速い

using Tk

widgets = Dict{Symbol, Union{Void, Tk.Widget}}()

function univPath(p)
  return replace(p, "\\", "/")
end

function main(p::AbstractString)
  widgets[:w] = w = Toplevel(p, 640, 480)
  tcl("pack", "propagate", w, false) # or pack_stop_propagate(w)
  bind(w, "<Destroy>", path -> widgets[:w] = nothing)

  cbk_file = function (path)
    println(path)
    d = ChooseDirectory()
    length(d) == 0 && (println("skipped: cd"); return 0)
    println(d)
    cd(d)
    set_value(widgets[:lbl], d)
    # println(get_items(widgets[:rb].buttons[2]))
    # set_items(widgets[:rb].buttons[2], d)
    o = GetOpenFile() # can not set directory (needs cd() ?)
    length(o) == 0 && (println("canceled: open"); return 0)
    println(o)
    s = GetSaveFile() # can not set directory (needs cd() ?)
    length(s) == 0 && (println("canceled: save"); return 0)
    println(s)
  end

  mbar = Menu(w)
  fmenu = menu_add(mbar, "(&F)ile")
  omenu = menu_add(mbar, "(&O)ptions")
  hmenu = menu_add(mbar, "(&H)elp")
  menu_add(fmenu, "開く(&O)...", path -> cbk_file(path))
  menu_add(fmenu, Separator(w))
  menu_add(fmenu, "終了(&X)", path -> destroy(w))
  cb = Checkbutton(w, "チェックボックス")
  set_value(cb, true)
  menu_add(omenu, cb)
  menu_add(omenu, Separator(w))
  # menu_add(omenu, Label(w, "ラベル"))
  widgets[:rb] = rb = Radio(w, ["option 1", "オプション 2"])
  set_value(rb, "option 1")
  menu_add(omenu, rb)
  menu_add(hmenu, "(&A)bout", path -> cbk_dsp(path))

  nb = Notebook(w)
  pack(nb, expand=true, fill="both")

  img = Image(univPath(Pkg.dir("Tk", "examples", "logo.gif")))
  f1 = Frame(nb, padding=[16,16,8,8], relief="groove")
  page_add(f1, "Tab 1")
  widgets[:lbl] = lbl = Label(f1, "label ラベル")
  grid(lbl, 1, 1, sticky="sw")
  b = Button(f1, "表示 selected options", img)
  grid(b, 2, 1, sticky="news")
  cbk_dsp(path) = println(@sprintf "%s: %s" path map(get_value, (cb, rb)))
  # callback_add(b, cbk_dsp)
  bind(b, "command", cbk_dsp)
  bind(b, "<Return>", cbk_dsp)
  sc = Slider(f1, 1:20)
  v = Label(f1, "value 選択ディレクトリ")
  v[:textvariable] = sc[:variable]
  grid(v, 3, 1, sticky="ne")
  grid(sc, 4, 1, sticky="ew")
  grid_columnconfigure(f1, 1, weight=1)
  grid_rowconfigure(f1, 1, weight=3)
  grid_rowconfigure(f1, 3, weight=1)

  f2 = Frame(nb, padding=[16,16,8,8], relief="groove")
  page_add(f2, "椨 2")
  p21 = Panedwindow(f2, "horizontal")
  # pack(p21, expand=true, fill="both")
  grid(p21, 1, 1, sticky="news")
  grid_columnconfigure(f2, 1, weight=1)
  grid_rowconfigure(f2, 1, weight=1)
  b2 = Button(p21, "鹽🐢 2")
  page_add(b2, 2)
  # callback_add(b2, cbk_dsp)
  bind(b2, "command", cbk_dsp)
  bind(b2, "<Return>", cbk_dsp)
  l2 = Label(p21, "paned2ラベル")
  page_add(l2, 1)
  ff = Frame(p21)
  formlayout(Entry(ff), "Name:")
  formlayout(Entry(ff), "Rank:")
  formlayout(Entry(ff), "Serial Number:")
  page_add(ff, 3)
  l3 = Label(p21, "paned3ラベル")
  page_add(l3, 2)
  set_value(p21, 100)
  tcl(p21, "sashpos", 1, 200)
  tcl(p21, "sashpos", 2, 300)

  # http://wiki.tcl.tk/20058
  bmp_sash_h = """
R0lGODlhBQB5AKECADMzM9TQyP///////yH+EUNyZWF0ZWQgd2l0aCBHSU1QACH5BAEKAAMALAAA
AAAFAHkAAAJOjA95y+0LUAxpUkufboLh1UFPiIyeKTqk8R1rpp5xysk1zbytoaPl/LsFczYiDlRE
Hl1J5pLXhD4DPSDLd7XChFnudgO2KC5izA6sqTQKADs=
"""
  tcl_eval("image create photo img:sash -data {$bmp_sash_h}") # => "img:sash"
  tcl_eval("""ttk::style element create Sash.xsash image [list img:sash] \\
    -border {1 1} -sticky ew -padding {1 1}""") # => "Sash.xsash"
  tcl_eval("ttk::style layout TPanedwindow { Sash.xsash }") # => ""

  f3 = Frame(nb, padding=[16,16,8,8], relief="groove")
  page_add(f3, "椨 3")

  set_value(nb, 2)

  Messagebox(title=p, message="Hello, 世界!") # to keep

  exists(w) && cbk_dsp(w) # skip after destroy(w)
  # widgets[:w] != nothing && cbk_dsp(w) # skip after destroy(w)
end

main("title日本語漢字表示申能")
