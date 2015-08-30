# hideauth.pl
#
# Stops eggdrop passwords from showing up in e.g. /msg botnick op password [#channel]
#
# Settings:
#		hideauth_commands: space-delimited case-insensitive list of eggdrop commands to filter (e.g. "op voice ident") (can be regexps)
#		hideauth_botsonly: if 1/ON, only hideauth for nicks in the bots list (because "op" is common Dutch word :)
#		hideauth_bots: space-delimited case-insensitive list of botnicks (can be regexps) (e.g. "notopic monicaoff")
#       hideauth_printactive: if ON, display the line in the active window rather than in the bot's query window
#
#		You can also change the "bot_command" format item:
#			$0 = command (op, ident, etc)
#			$1 = (optional) channel (from "op password #channel")
#			$2 = nick command is sent to
#			My default format is (in case you break it): 'eggdrop command {reason $0 %K****%n$1} sent to {channick_hilight $2}'
#
# Thanks to Joost "Garion" Vunderink for advice and testing ^_^
#

# New in 1.10
#   - new setting hideauth_printactive (default: on)
#   - should now work for passwords with non-letter characters in (oops :) [thanks to someone whose name escapes me at the moment]

use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(signal_add_first settings_get_str settings_get_bool settings_add_str settings_add_bool signal_stop theme_register);

$VERSION = '1.10';
%IRSSI = (
    authors	=> 'JamesOff',
    contact	=> 'james@jamesoff.net',
    name	=> 'hideauth',
    description	=> 'Stops eggdrop passwords showing up',
    license	=> 'Public Domain',
    url		=> 'http://www.jamesoff.net',
    changed	=> '16/09/2002 10:15',
);

theme_register([
  'bot_command', 'eggdrop command {reason $0 %K****%n$1} sent to {channick_hilight $2}'
]);


sub intercept_message {
	my ($server, $message, $target, $orig_target) = @_;
	my $commands = settings_get_str('hideauth_commands');
	my $botsOnly = settings_get_bool('hideauth_botsonly');
	my $bots = settings_get_str('hideauth_bots');
	$bots =~ tr/ /|/;

	#check for bots only and compare target nick
	return if (($botsOnly == 1) && ($target !~ /($bots)/i));

	#check the first word to see if it's a command
	$commands =~ tr/ /|/;
	if ($message =~ /^($commands) \S+( .+)?/i) {
		#it's a match, it's handle it :)
		my ($command, $dest) = ($1, $2);
		if (settings_get_bool('hideauth_printactive') == 1) {
			my $window = Irssi::active_win();
			$window->printformat(MSGLEVEL_CRAP, 'bot_command', $command, $dest, $target);
		}
		else {
			$server->printformat($target, MSGLEVEL_CRAP, 'bot_command', $command, $dest, $target);
		}
		signal_stop();
	}
}

signal_add_first('message own_private', 'intercept_message');
#space-separated list of bot commands
settings_add_str('misc','hideauth_commands','op voice auth ident pass newpass rehash notes');

#one hideauth for listed bots (below)
settings_add_bool('misc','hideauth_botsonly',0);

#space-separated list of bot nicks
settings_add_str('misc','hideauth_bots','');

#if 1, print always to active window (else it'll go to the bot's query/status window)
settings_add_bool('misc','hideauth_printactive',1);
