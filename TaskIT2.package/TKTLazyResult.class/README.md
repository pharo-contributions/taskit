A lazy result is an object that represents, almost transparently, the value of the task execution. This lazy result will become into the value of the result once it is available, or under demand (for example, when a message is sent to it). Lazy results support a style of programming that ressembles the synchronous style, while performing asynchronous if the result is not used. 

[[[
future := [ employee computeBaseSallary ] shootIt.
result := future asResult.

subTotal := employee sumSallaryComponents

result + subTotal
]]]

Note: Lazy results are to be used with care. They use Pharo's ==become:== facility, and so, it will freeze the system to update object references.

Lazy results can be used to easily synchronize tasks. One task running in paralell with another one and waiting for it to finish can use a lazy result object to perform transparently as much work as it can in paralell. Only when the result object is sent a message the 

[[[
future := [ employee computeBaseSallary ] shootIt.
baseSallary := future asResult.

[ employee sumSallaryComponents + baseSallary ] shootIt value.
]]]