I am a helper that knows how to store a reference to another process.

I store a reference to a process and a list of TKTContextHolder instances that hold copies of the referenced process' contexts. I know how to create a stack for the debugger recursively and I provide convenience methods to traverse the list of context holders.