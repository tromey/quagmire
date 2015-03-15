# Quagmire #

Quagmire is intended to replace GNU Automake and GNU Libtool with a suite of
GNU make include files -- no preprocessing required.  Quagmire will
also include configuration checks, like GNU Autoconf.

Advantages to this approach include:

  * Simpler to understand.  Automake's preprocessing introduces a layer of confusion.
  * Smaller distribution footprint.  Automake-generated Makefiles tend to be very large, bloating a project's source tar.
  * Faster.  We should be able to eliminate much of the overhead of libtool (perhaps by making some simplifying assumptions).
  * More scalable.  Quagmire will be able to run configuration checks in parallel with other parts of the build.

Quagmire owes a debt to the GNU autotools, and may lift code from them, but it is probably not going to be completely backward compatible.  In most cases, transitioning to Quagmire should be fairly simple.

See the files README and TODO in the Quagmire sources to see how to use it and what kinds of work it still needs.  Quagmire is still in very early in development -- you can influence its course easily!