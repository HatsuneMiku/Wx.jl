# -*- coding: utf-8 -*-

using Base.Test

include("./wx_tests.jl")
include("./test_tk.jl")
w = test_tk("title日本語漢字表示申能")
sleep(1.5)
exists(w) && destroy(w)
