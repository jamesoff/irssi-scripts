# windowsort

use strict;
use Irssi;

use vars qw{%IRSSI};

%IRSSI = (
	name => 'windowsort',
	authors => 'James Seward',
	contact => 'james@jamesoff.net',
	url => 'http://jamesoff.net',
);

my %window_times = ();
my $change_time = 0;

sub signal_window_changed {
  my ($window, $old_window) = @_;

	if ($old_window) {
		if ($change_time > 0) {
			my $window_time = time() - $change_time;
			if ($window_time > 0) {
				my $previous_time = 0;
				if (exists $window_times{$old_window->{refnum}}) {
					$previous_time = $window_times{$old_window->{refnum}};
				}
				# cap time to max_time in case we got left on this window idle
				if ($window_time > Irssi::settings_get_int('windowsort_max_time')) {
					$window_time = Irssi::settings_get_int('windowsort_max_time');
				}
				$previous_time += $window_time;
				$window_times{$old_window->{refnum}} = $previous_time;
			}
		}
	}
	$change_time = time();
}

sub windowsort_list {
	my @sorted = sort { $window_times{$b} <=> $window_times{$a} } keys %window_times;
	my $target_window = 1;
	foreach my $moo (@sorted) {
		my $window = Irssi::window_find_refnum($moo);
		my $win_name = $window->{name};
		if ($win_name eq "") {
			$win_name = $window->get_active_name();
		}
		my $correct = $target_window == $moo ? " (Correct)" : "";
		Irssi::print("Window " . $moo . " $win_name should move to position $target_window$correct (" . $window_times{$moo} . " seconds total)");
		$target_window++;
	}
	return;
}


sub command_windowsort {
	my($data,$server,$witem) = @_;

	windowsort_list();
	return;

	#BROKEN
	my @sorted = sort { $window_times{$b} > $window_times{$a} } keys %window_times;
	my $target_window = 1;
	foreach my $moo (@sorted) {
		Irssi::print("Window " . $moo . " (" . $window_times{$moo} . " seconds total)");
		my $window = Irssi::window_find_refnum($moo);
		my $win_name = $window->{name};
		Irssi::print("Window name is $win_name");
		Irssi::print("/window goto $moo");
		Irssi::print("/window move $target_window");
		$window->set_refnum($target_window);
		$target_window++;
	}
	return;
	Irssi::print("clearing stats as windows have moved");
	%window_times = ();
}

Irssi::command_bind('windowsort', 'command_windowsort');
Irssi::signal_add('window changed', 'signal_window_changed');
Irssi::settings_add_int('windowsort', 'windowsort_max_time', 300);
