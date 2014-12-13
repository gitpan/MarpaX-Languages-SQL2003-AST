use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::SQL2003::AST::Actions::Blessed;
use parent 'MarpaX::Languages::SQL2003::AST::Actions';
use SUPER;
use Scalar::Util qw/blessed/;

# ABSTRACT: Translate SQL-2003 source to an AST - Blessed semantic actions

our $VERSION = '0.003'; # TRIAL VERSION


sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    return $self;
}

# ----------------------------------------------------------------------------------------

sub _nonTerminalSemantic {
  my $self = shift;

  my ($lhs, @rhs) = $self->_getRuleDescription();
  my $maxRhs = $#rhs;

  $lhs =~ s/^<//;
  $lhs =~ s/>$//;

  my @array = ();

  foreach (0..$#_) {
    my $child;
    my $index = $_;
    if (! blessed($_[$index])) {
      #
      # This is a lexeme
      #
      my $raw = {start => $_[$index]->[0], length => $_[$index]->[1], text => $_[$index]->[2], value => $_[$index]->[3]};
      my $i = 4;
      while ($#{$_[$index]} >= $i) {
	$raw->{$_[$index]->[$i]} = $_[$index]->[$i+1];
	$i += 2;
      }
      $child = bless($raw, $rhs[$index]);
    } else {
      $child = $_[$index];
    }
    push(@array, $child);
  }

  return bless(\@array, $lhs);
}

# ----------------------------------------------------------------------------------------

sub _lexemeValue {
  my ($self, $node) = @_;

  if (! defined($node)) {
    return undef;
  }

  return $node->[2];
}

# ----------------------------------------------------------------------------------------

sub _lexemeStart {
  my ($self, $node) = @_;

  if (! defined($node)) {
    return undef;
  }

  return $node->[0];
}

# ----------------------------------------------------------------------------------------

sub _lexemeLength {
  my ($self, $node) = @_;

  if (! defined($node)) {
    return undef;
  }

  return $node->[1];
}

# ----------------------------------------------------------------------------------------

sub _childByIndex {
  my ($self, $node, $index) = @_;

  if (! defined($node)) {
    return undef;
  }

  return ($index <= $#{$node}) ? $node->[$index] : undef;
}

# ----------------------------------------------------------------------------------------

sub _unicodeDelimitedIdentifier { super(); }

# ----------------------------------------------------------------------------------------

sub _unicodeDelimitedIdentifierUescape { super(); }

# ----------------------------------------------------------------------------------------

sub _showProgressAndExit { super(); }

# ----------------------------------------------------------------------------------------

sub _nationalCharacterStringLiteral { super(); }

# ----------------------------------------------------------------------------------------

sub _characterStringLiteral { super(); }

# ----------------------------------------------------------------------------------------

sub _unsignedNumericLiteral { super(); }

# ----------------------------------------------------------------------------------------

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MarpaX::Languages::SQL2003::AST::Actions::Blessed - Translate SQL-2003 source to an AST - Blessed semantic actions

=head1 VERSION

version 0.003

=head1 DESCRIPTION

This modules give the blessed semantic actions associated to SQL-2003 grammar

=head1 AUTHOR

Jean-Damien Durand <jeandamiendurand@free.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jean-Damien Durand.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
