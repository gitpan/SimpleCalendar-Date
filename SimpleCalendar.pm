# =========================================================================#
# SimpleCalendar 1.1 - A Simple Interface For Monthly Calendars
# Mohammad Mahmoud Khajah - <mmkhajah@syr.edu>
# Modified by Dmitry Sagaev - <zurik@mail.ru>
# =========================================================================#

package SimpleCalendar;

use strict;
use warnings;
use Time::Local;
use Date;

our %dofw = ( 	0 => 'sunday',
		1 => 'monday',
		2 => 'tuesday',
		3 => 'wednesday',
		4 => 'thursday',
		5 => 'friday',
		6 => 'saturday' );

our %month = (	1 => 'Jan', 
		2 => 'Feb',
		3 => 'Mar',
		4 => 'Apr',
		5 => 'May',
		6 => 'Jun',
		7 => 'Jul',
		8 => 'Aug',
		9 => 'Sen',
		10 => 'Oct', 
		11 => 'Nov',
		12 => 'Dec'	);

# --------------------------------------------------------------------------
# obj new(int month, int year, string weekStart)
# Description: This will create a new SimpleCalendar object with the
# sepcified parameters. Note that month must be from 1 to 12, year must
# be a four digit number with no leading zeros and weekStart is the
# day which is the start of the week. ( sunday .. saturday )
# --------------------------------------------------------------------------
sub new {
	my $proto    = shift;
	my $month    = shift;
	my $year     = shift;
	my $weekStart= shift;
	my $class	 = ref($proto) || $proto;
	my %dayIDs	 = ();
	my %self	 = ();
	
	# Map names to IDs in the sunday-based week
	our %dayIDs = (
		'monday'	=> 0,
		'tuesday'	=> 1,
		'wednesday'	=> 2,
		'thursday'	=> 3,
		'friday'	=> 4,
		'saturday'	=> 5,
		'sunday'	=> 6,
	);
	
	# Remove all leading zeros from the year
	$year =~ s/^0+//;
	
	# Lower-case weekStart for easier usage
	$weekStart = lc($weekStart);
	
	# Make sure month, year, and weekStart are valid
	return if 		( ($month < 1) || ($month > 12) );
	return unless 	( $year =~ /\d{4}/ );
	return unless   ( grep { $_ eq $weekStart } keys %dayIDs );
	
	# Everything's good ... proceed
	$self{'id'}		= $dayIDs{$weekStart};
	$self{'month'}	= $month - 1;
	$self{'year'}	= $year;
	
	# Object on the move!
	return bless \%self, $class;
}

# --------------------------------------------------------------------------
# int _GenerateTimeStamp()
# Description: This method will generate UNIX timestamp for the month
# and year provided. Note that the timestamp is always generated
# for the 1st day in the month.
# --------------------------------------------------------------------------
sub _GenerateTimeStamp {
	my $self = shift;
	
	return timelocal(1,0,0,1,$self->{'month'},$self->{'year'});
}

# --------------------------------------------------------------------------
# int _GetYearType()
# Description: This method will return 1 if the year provided is
# a leap year, and 0 otherwise.
# --------------------------------------------------------------------------
sub _GetYearType {
	my $self = shift;
	
	if ( $self->{'year'} % 4 == 0) {
		unless(($self->{'year'} % 100 == 0) && ($self->{'year'} % 400 == 0)) {
			return 1;
		}
	}
	
	return undef;
}

# --------------------------------------------------------------------------
# int _GetDayOfWeek(timestamp)
# Description: This method will retrive the day of week from the provided
# timestamp. It will also convert the resultant number into the week
# system defined in $self->{'id'}.
# --------------------------------------------------------------------------
sub _GetDayOfWeek {
	my $self = shift;
	my $timestamp = shift;
	my $dayOfWeek = undef;
	
	# Get day of week in the sunday-based system
	($dayOfWeek) = (localtime($timestamp))[6];
	
	# Convert that into our system
	return ($dayOfWeek + ( 7 - $self->{'id'})) % 7;
}

# --------------------------------------------------------------------------
# arrayref BuildCalendar()
# Description: This method will return a data structure for the calendar
# of the month and year defined in the object.
# --------------------------------------------------------------------------
sub BuildCalendar {
	my $self = shift;
	my @calendar  = ([],[],[],[],[]);
	my $firstDay = undef;
	my @daysOfMonth = qw(31 28 31 30 31 30 31 31 30 31 30 31);
	my $row = 0;
	my $dayOfWeek = undef;
	my $rem = 0;
	
	# If it is a leap year, add one to feb
	$daysOfMonth[1] = 29 if ( $self->_GetYearType() );
	
	# Get the first day of the week
	$firstDay = $self->_GetDayOfWeek($self->_GenerateTimeStamp());
	
	# Get day of week pointer
	$dayOfWeek = $firstDay;
	
	# Start loading data into the structure
	for ( my $i = 1; $i <= $daysOfMonth[$self->{'month'}]; $i++ ) {
		# move to next row
		if ( $dayOfWeek == 7 ) {
			$row += 1;
			$dayOfWeek = 0;
		}
		
		# add data
		$calendar[$row][$dayOfWeek] = "$i";
		
		# increase day of week
		$dayOfWeek++;
	}
	# how many positions to fill
	$rem = 6 - $dayOfWeek + 1;
	
	if ( $rem > 0 ) {
		for ( my $i = 0; $i < $rem; $i++ ) {
			$calendar[$row][$dayOfWeek] = undef;
			$dayOfWeek++;
		}
	}
	
	# if the last week wasn't filled, then remove it
	if ( @{$calendar[4]} == 0 ) {
		pop(@calendar);
	}
	
	# done
	return \@calendar;
}

# --------------------------------------------------------------------------
# int AccessMonth()
# --------------------------------------------------------------------------
sub AccessMonth {
	my $self = shift;
	return $self->{'month'};
}

# --------------------------------------------------------------------------
# int AccessYear()
# --------------------------------------------------------------------------
sub AccessYear {
	my $self = shift;
	return $self->{'year'};
}

# --------------------------------------------------------------------------
# int AccessStartOfWeek()
# --------------------------------------------------------------------------
sub AccessStartOfWeek {
	my $self = shift;
	return $self->{'id'};
}

# --------------------------------------------------------------------------
# Date get_tDate() 
# Description: This method will return a structure
# of the current day, month and year defined in the object.
# --------------------------------------------------------------------------
sub get_tDate {
 
	my ($sec, $min, $hour, $day, $mon, $year, $dofw) = localtime();
	
	$mon+=1;
	$year+=1900;
	$dofw=$dofw{$dofw};

	my $obj = new Date;
	$obj->setDate($day, $mon, $year);

	return $obj;
}

=head1 NAME

SimpleCalendar 1.1 - A Simple Interface For Monthly Calendars

=head1 SYNOPSIS

	use SimpleCalendar;
	use Data::Dumper;
	
	my $obj = new SimpleCalendar(6, 2004, 'monday');
	my $cal = $obj->BuildCalendar();

=head1 DESCRIPTION

This module provides a fairly simple interface for creating monthly
calendars. It makes use of C<Time::Local> module which is usually
bundled with Perl by default.

=head2 Methods

=over 13

=item C<new>

Returns a new SimpleCalendar object. It takes three arguments: The month 
( which ranges from 1 to 12 ), the year ( which must be a 4 digit number with
no leading zeros ) and the start of the week ( from sunday to saturday ).

=item C<BuildCalendar>

Returns an array reference which contains the calendar. Each element of this
array represents a week and each element of a week is the day. Days that
are before the first day of the month are assigned C<undef> values as well as days
that are after the last day of the month. For example, the structure
that will be returned from the previous example is:

	$cal = [[undef,'1','2','3','4','5','6'],['7','8','9','10','11','12','13'],['14'
	,'15','16','17','18','19','20'],['21','22','23','24','25','26','27'],['28','29',
	'30',undef,undef,undef,undef]];

=back

=head1 INSTALLATION

Just download the file to whatever location you like and C<use> it in
your scripts.

=head1 BUGS

Not known.

=head1 AUTHOR

Mohammad Mahmoud Khajah - <mmkhajah@syr.edu>
Dmitry Sagaev - <zurik@mail.ru>

=head1 SEE ALSO

L<Time::Local>

=cut

1;

