Monitor how much time you spend in each window in irssi.

Originally, this was going to move your windows around for you (on demand) so they were sorted by how much you used them, but I never got round to that. Instead, it'll output a list of windows in the order it thinks you should have them, and you can move them around with `/window move N`.

This isn't really finished, so please bear in mind the caveats below.

* `/script load windowsort`
* Optionally `/set windowsort_max_time` to a number of seconds, which is the maximum a window can score in one go. Defaults to 5 minutes. The idea is that if you leave your client idle, the window you're on can't accumulate a massive score it doesn't deserve.
* Use irssi for a while
* `/windowtidy`
* Obersve the list and use `/window goto N` and `/window move N` to rearrange them. Once you've moved windows around, you'll need to reload the script as it tracks by window number not by name.

