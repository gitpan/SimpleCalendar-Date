# Date Object Package by Dmitry Sagaev <zurik@mail.ru>

package Date;

use strict;
use warnings;

# --------------------------------------------------------------------------
# obj new()
# Description: This will create a new date object.
# --------------------------------------------------------------------------
sub new {
	my $date = {
		the_day => 1,  the_mon => 1,  the_year => 1000
	};

	bless($date);
	return $date;
}

# --------------------------------------------------------------------------
# int day([int day])
# Get/Set method for a day parameter.
# --------------------------------------------------------------------------
sub day {
	my $self = shift;
	$self->{the_day} = shift if (@_);
	return $self->{the_day};
}

# --------------------------------------------------------------------------
# int mon([int mon])
# Get/Set method for a month parameter.
# --------------------------------------------------------------------------
sub mon {
	my $self = shift;
	$self->{the_mon} = shift if (@_);
	return $self->{the_mon};
}

# --------------------------------------------------------------------------
# int year([int year])
# Get/Set method for a year parameter.
# --------------------------------------------------------------------------
sub year {
	my $self = shift;
	$self->{the_year} = shift if (@_);
	return $self->{the_year};
}


# --------------------------------------------------------------------------
# void setDate(int day, int month, int year)
# Set method for day,month,year parameters.
# --------------------------------------------------------------------------
sub setDate {
	if (@_ == 4) {
		my $self = shift;
		$self->day(shift);
		$self->mon(shift);
		$self->year(shift);
	} else {
		print "There is not enough parameters for successful evaluating!\n";
	}
}

# --------------------------------------------------------------------------
# void setMY(int month, int year)
# Set method for month,year parameters.
# --------------------------------------------------------------------------
sub setMY {
	if (@_ == 3) {
		my $self = shift;
		$self->mon(shift);
		$self->year(shift);
	} else {
		print "There is not enough parameters for successful evaluating!\n";
	}
}

# --------------------------------------------------------------------------
# int monMinus(int month)
# Get method, returning current month value minus 1.
# --------------------------------------------------------------------------
sub monMinus {
	my $self = shift;
	my $result;
	if ($self->mon eq '1')  {
		$result=12;
	} else {
		$result=$self->mon-1;
	}
	return $result;
}

# --------------------------------------------------------------------------
# int monPlus(int month)
# Get method, returning current month value plus 1.
# --------------------------------------------------------------------------
sub monPlus {
	my $self = shift;
	my $result;
	if ($self->mon eq '12')  {
		$result=1;
	} else {
		$result=$self->mon+1;
	}
	return $result;
}

# --------------------------------------------------------------------------
# void print ()
# Print day,month,year parameters.
# --------------------------------------------------------------------------
sub print {
	my $self = shift;
	print $self->day, "/", $self->mon, "/", $self->year, "\n";
}

1;