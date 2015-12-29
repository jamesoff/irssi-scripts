A script to report on your typing speed.

* Dump in your `.irssi/scripts` folder as usual
* `/script load wpm` to load it
* Add its statusbar item somewhere. To put it on the end of the input line, do `/statusbar prompt add wpm`. If you want to put it on a different statusbar, put that instead of `prompt`. See `/help statusbar` for more information.
* Type.

The first number on the statusbar item is the WPM of your last line. The number in brackets is your average (since the script was loaded). The next number is the characters per minute of your last line, followed by your average. To reset your averages, reload the script.

It should work fine out of the box, but if you want to tweak it there are a couple of settings:

* `/set wpm_strict ON|OFF`: When on (default), anything that adds more than one character at a time to the line invalidates that line and it will be ignored. The usual suspects for this are nick completion and using `^Y` to insert the cutbuffer. *Pasting into your term is not detected and will inflate your WPM.* When off, pastes of <= 9 characters are allowed (nick completion on sensible networks).
* `/set wpm_simple ON|OFF`: When off (default), words of more than 5 characters can count as more than one word. See Wikipedia's article on [typing](https://en.wikipedia.org/wiki/Typing#Words_per_minute). When on, words over 5 characters still only count as one.
* `/set show_wpm ON|OFF`: When on (default), show WPM stats in the statusbar.
* `/set show_cpm ON|OFF`: When on (default), show CPM stats in the statusbar.

Even if the statusbar item isn't showing stats, or if you remove the statusbar item entirely, the stats are still calculated.</p>
