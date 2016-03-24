=pod

=encoding UTF-8

=head1 NAME

Algorithm::Networksort::Best - Optimized Sorting Networks.

=cut

package Algorithm::Networksort::Best;

use 5.010001;

use Algorithm::Networksort;
use Carp;
use Exporter;
use vars qw(@ISA %EXPORT_TAGS @EXPORT_OK);
use strict;
use warnings;

@ISA = qw(Exporter);

%EXPORT_TAGS = (
	'all' => [ qw(
		nwsrt_best
		nw_best_names
		nw_best_title
	) ],
);

@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '1.30';

#
# The hashes represent each network, with a short, hopefully descriptive, key.
#
my %nw_best_by_name = (
	floyd09 => {
		inputs => 9,
		depth => 9,
		title => '9-input Network by Robert W. Floyd',
		comparators =>
		[[0,1], [3,4], [6,7], [1,2], [4,5], [7,8], [0,1], [3,4],
		[6,7], [0,3], [3,6], [0,3], [1,4], [4,7], [1,4], [2,5],
		[5,8], [2,5], [1,3], [5,7], [2,6], [4,6], [2,4], [2,3],
		[5,6]]},
	senso09 => {
		inputs => 9,
		depth => 8,
		title => '9-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[2,6], [0,5], [1,4], [7,8], [0,7], [1,2], [3,5], [4,6],
		[5,8], [1,3], [6,8], [0,1], [4,5], [2,7], [3,7], [3,4],
		[5,6], [1,2], [1,3], [6,7], [4,5], [2,4], [5,6], [2,3],
		[4,5]]},
	waksman10 => {
		inputs => 10,
		depth => 9,
		title => '10-Input Network by A. Waksman',
		comparators =>
		[[4,9], [3,8], [2,7], [1,6], [0,5], [1,4], [6,9], [0,3],
		[5,8], [0,2], [3,6], [7,9], [0,1], [2,4], [5,7], [8,9],
		[1,2], [4,6], [7,8], [3,5], [2,5], [6,8], [1,3], [4,7],
		[2,3], [6,7], [3,4], [5,6], [4,5]]},
	senso10 => {
		inputs => 10,
		depth => 8,
		title => '10-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[1,4], [7,8], [2,3], [5,6], [0,9], [2,5], [0,7], [8,9],
		[3,6], [4,9], [0,1], [0,2], [6,9], [3,5], [4,7], [1,8],
		[3,4], [5,8], [6,7], [1,2], [7,8], [1,3], [2,5], [4,6],
		[2,3], [6,7], [4,5], [3,4], [5,6]]},
	shapirogreen11 => {
		inputs => 11,
		depth => 9,
		title => '11-Input by G. Shapiro and M. W. Green',
		comparators =>
		[[0,1], [2,3], [4,5], [6,7], [8,9], [1,3], [5,7], [0,2],
		[4,6], [8,10], [1,2], [5,6], [9,10], [1,5], [6,10], [5,9],
		[2,6], [1,5], [6,10], [0,4], [3,7], [4,8], [0,4], [1,4],
		[7,10], [3,8], [2,3], [8,9], [2,4], [7,9], [3,5], [6,8],
		[3,4], [5,6], [7,8]]},
	senso11 => {
		inputs => 11,
		depth => 10,
		title => '11-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[0,9], [2,8], [3,7], [4,6], [1,5], [1,3], [2,4], [6,10],
		[7,8], [5,9], [0,6], [1,2], [8,10], [9,10], [0,1], [5,7],
		[3,4], [6,8], [2,6], [1,5], [7,8], [4,9], [2,3], [8,9],
		[1,2], [4,6], [3,5], [6,7], [7,8], [2,3], [4,6], [5,6],
		[3,4], [6,7], [4,5]]},
	shapirogreen12 => {
		inputs => 12,
		depth => 9,
		title => '12-Input by G. Shapiro and M. W. Green',
		comparators =>
		[[0,1], [2,3], [4,5], [6,7], [8,9], [10,11], [1,3], [5,7],
		[9,11], [0,2], [4,6], [8,10], [1,2], [5,6], [9,10], [1,5],
		[6,10], [5,9], [2,6], [1,5], [6,10], [0,4], [7,11], [3,7],
		[4,8], [0,4], [7,11], [1,4], [7,10], [3,8], [2,3], [8,9],
		[2,4], [7,9], [3,5], [6,8], [3,4], [5,6], [7,8]]},
	senso12 => {
		inputs => 12,
		depth => 9,
		title => '12-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[0,5], [2,7], [4,10], [3,6], [8,11], [1,9], [5,6], [1,8],
		[0,3], [2,4], [9,11], [7,10], [7,9], [10,11], [1,2], [6,11],
		[0,1], [4,8], [5,8], [1,4], [3,7], [2,5], [7,10], [6,9],
		[2,3], [4,6], [8,10], [1,2], [9,10], [6,8], [3,4], [8,9],
		[2,3], [5,7], [4,5], [6,7], [7,8], [5,6], [3,4]]},
	end13 => {
		inputs => 13,
		depth => 10,
		title => '13-Input Network Generated by the END algorithm, by Hugues Juill�',
		comparators =>
		[[1,7], [9,11], [3,4], [5,8], [0,12], [2,6], [0,1], [2,3],
		[4,6], [8,11], [7,12], [5,9], [0,2], [3,7], [10,11], [1,4],
		[6,12], [7,8], [11,12], [4,9], [6,10], [3,4], [5,6], [8,9],
		[10,11], [1,7], [2,6], [9,11], [1,3], [4,7], [8,10], [0,5],
		[2,5], [6,8], [9,10], [1,2], [3,5], [7,8], [4,6], [2,3],
		[4,5], [6,7], [8,9], [3,4], [5,6]]},
	senso13 => {
		inputs => 13,
		depth => 12,
		title => '13-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[4,8], [0,9], [3,7], [2,5], [6,11], [1,12], [0,6], [2,4],
		[5,8], [7,12], [1,3], [10,11], [9,11], [0,1], [8,12], [8,10],
		[2,8], [11,12], [0,2], [7,9], [5,9], [3,6], [3,5], [1,8],
		[4,6], [4,7], [10,11], [6,9], [3,4], [1,2], [9,11], [1,3],
		[6,10], [2,4], [2,3], [9,10], [6,8], [5,7], [5,6], [7,8],
		[3,5], [8,9], [4,5], [6,7], [5,6]]},
	green14 => {
		inputs => 14,
		depth => 10,
		title => '14-Input Network by M. W. Green',
		comparators =>
		[[0,1], [2,3], [4,5], [6,7], [8,9], [10,11], [12,13], [0,2],
		[4,6], [8,10], [1,3], [5,7], [9,11], [0,4], [8,12], [1,5],
		[9,13], [2,6], [3,7], [0,8], [1,9], [2,10], [3,11], [4,12],
		[5,13], [5,10], [6,9], [3,12], [7,11], [1,2], [4,8], [1,4],
		[7,13], [2,8], [2,4], [5,6], [9,10], [11,13], [3,8], [7,12],
		[6,8], [10,12], [3,5], [7,9], [3,4], [5,6], [7,8], [9,10],
		[11,12], [6,7], [8,9]]},
	senso14 => {
		inputs => 14,
		depth => 11,
		title => '14-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[0,6], [2,3], [8,12], [4,5], [1,10], [7,13], [9,11], [3,6],
		[4,7], [5,13], [1,8], [10,12], [0,2], [11,12], [0,9], [1,4],
		[6,13], [12,13], [0,1], [2,7], [3,5], [9,10], [3,8], [7,10],
		[5,8], [2,9], [6,11], [4,6], [8,12], [1,3], [10,11], [2,4],
		[11,12], [1,2], [8,10], [3,9], [3,4], [2,3], [10,11], [5,7],
		[7,8], [6,9], [5,6], [4,5], [8,9], [6,7], [9,10], [3,4],
		[5,6], [7,8], [6,7]]},
	green15 => {
		inputs => 15,
		depth => 10,
		title => '15-Input Network by M. W. Green',
		comparators =>
		[[0,1], [2,3], [4,5], [6,7], [8,9], [10,11], [12,13], [0,2],
		[4,6], [8,10], [12,14], [1,3], [5,7], [9,11], [0,4], [8,12],
		[1,5], [9,13], [2,6], [10,14], [3,7], [0,8], [1,9], [2,10],
		[3,11], [4,12], [5,13], [6,14], [5,10], [6,9], [3,12], [13,14],
		[7,11], [1,2], [4,8], [1,4], [7,13], [2,8], [11,14], [2,4],
		[5,6], [9,10], [11,13], [3,8], [7,12], [6,8], [10,12], [3,5],
		[7,9], [3,4], [5,6], [7,8], [9,10], [11,12], [6,7], [8,9]]},
	senso15 => {
		inputs => 15,
		depth => 10,
		title => '15-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[12,13], [5,7], [3,11], [2,10], [4,9], [6,8], [1,14], [11,14],
		[1,3], [7,10], [0,12], [4,6], [2,5], [8,9], [0,2], [9,14],
		[1,4], [0,1], [5,6], [7,8], [11,13], [3,12], [5,11], [9,10],
		[8,12], [2,4], [6,13], [3,7], [2,3], [12,14], [10,13], [1,5],
		[13,14], [1,2], [3,5], [10,12], [12,13], [2,3], [8,11], [4,9],
		[10,11], [6,7], [5,6], [4,8], [7,9], [4,5], [9,11], [11,12],
		[3,4], [6,8], [7,10], [9,10], [5,6], [7,8], [8,9], [6,7]]},
	green16 => {
		inputs => 16,
		depth => 10,
		title => '16-Input Network by M. W. Green',
		comparators =>
		[[0,1], [2,3], [4,5], [6,7], [8,9], [10,11], [12,13], [14,15],
		[0,2], [4,6], [8,10], [12,14], [1,3], [5,7], [9,11], [13,15],
		[0,4], [8,12], [1,5], [9,13], [2,6], [10,14], [3,7], [11,15],
		[0,8], [1,9], [2,10], [3,11], [4,12], [5,13], [6,14], [7,15],
		[5,10], [6,9], [3,12], [13,14], [7,11], [1,2], [4,8], [1,4],
		[7,13], [2,8], [11,14], [2,4], [5,6], [9,10], [11,13], [3,8],
		[7,12], [6,8], [10,12], [3,5], [7,9], [3,4], [5,6], [7,8],
		[9,10], [11,12], [6,7], [8,9]]},
	senso16 => {
		inputs => 16,
		depth => 10,
		title => '16-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[12,13], [5,7], [3,11], [2,10], [0,15], [4,9], [6,8], [1,14],
		[11,14], [1,3], [7,10], [0,12], [4,6], [2,5], [8,9], [13,15],
		[10,15], [0,2], [9,14], [1,4], [0,1], [14,15], [5,6], [7,8],
		[11,13], [3,12], [5,11], [9,10], [8,12], [2,4], [6,13], [3,7],
		[2,3], [12,14], [10,13], [1,5], [13,14], [1,2], [3,5], [10,12],
		[12,13], [2,3], [8,11], [4,9], [10,11], [6,7], [5,6], [4,8],
		[7,9], [4,5], [9,11], [11,12], [3,4], [6,8], [7,10], [9,10],
		[5,6], [7,8], [8,9], [6,7]]},
	senso17 => {
		inputs => 17,
		depth => 17,
		title => '17-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[5,11], [4,9], [7,12], [0,14], [2,16], [1,15], [3,8], [6,13],
		[3,10], [8,13], [4,7], [9,12], [0,2], [14,16], [1,6], [10,15],
		[3,5], [11,13], [0,4], [12,16], [1,3], [13,15], [0,1], [15,16],
		[2,9], [7,14], [5,10], [6,11], [5,7], [6,8], [8,10], [2,3],
		[8,14], [9,11], [12,13], [4,6], [10,14], [4,5], [7,9], [11,13],
		[1,2], [14,15], [1,8], [13,15], [1,4], [2,5], [11,14], [13,14],
		[2,4], [6,12], [9,12], [3,10], [3,8], [6,7], [10,12], [3,6],
		[3,4], [12,13], [10,11], [5,6], [11,12], [4,5], [7,8], [8,9],
		[6,8], [9,11], [5,7], [6,7], [9,10], [8,9], [7,8]]},
	sat17 => {
		inputs => 17,
		depth => 10,
		title => '17-Input Network by M. Codish, L. Cruz-Filipe, T. Ehlers, M. M�ller, P. Schneider-Kamp',
		comparators =>
		[[1,2], [3,4], [5,6], [7,8], [9,10], [11,12], [13,14], [15,16],
		[2,4], [6,8], [10,12], [14,16], [1,3], [5,7], [9,11], [13,15],
		[4,8], [12,16], [3,7], [11,15], [2,6], [10,14], [1,5], [9,13],
		[0,3], [4,7], [8,16], [1,13], [14,15], [6,12], [5,11], [2,10],
		[1,16], [3,6], [7,15], [4,14], [0,13], [2,5], [8,9], [10,11],
		[0,1], [2,8], [9,15], [3,4], [7,11], [12,14], [6,13], [5,10],
		[2,15], [4,10], [11,13], [3,8], [9,12], [1,5], [6,7], [1,3],
		[4,6], [7,9], [10,11], [13,15], [0,2], [5,8], [12,14], [0,1],
		[2,3], [4,5], [6,8], [9,11], [12,13], [14,15], [7,10], [1,2],
		[3,4], [5,6], [7,8], [9,10], [11,12], [13,14], [15,16]]},
	alhajbaddar18 => {
		inputs => 18,
		depth => 11,
		title => '18-Input Network by Sherenaz Waleed Al-Haj Baddar',
		comparators =>
		[[0,1], [2,3], [4,5], [6,7], [8,9], [10,11], [12,13], [14,15],
		[16,17], [0,2], [1,3], [4,6], [5,7], [8,10], [9,11], [12,17],
		[13,14], [15,16], [0,4], [1,5], [2,6], [3,7], [9,10], [8,12],
		[11,16], [13,15], [14,17], [7,16], [6,17], [3,5], [10,14], [11,12],
		[9,15], [2,4], [1,13], [0,8], [16,17], [7,14], [5,12], [3,15],
		[6,13], [4,10], [2,11], [8,9], [0,1], [1,8], [14,16], [6,9],
		[7,13], [5,11], [3,10], [4,15], [4,8], [14,15], [5,9], [7,11],
		[1,2], [12,16], [3,6], [10,13], [5,8], [11,14], [2,3], [12,13],
		[6,7], [9,10], [7,9], [3,5], [12,14], [2,4], [13,15], [6,8],
		[10,11], [13,14], [11,12], [9,10], [7,8], [5,6], [3,4], [12,13],
		[10,11], [8,9], [6,7], [4,5]]},
	senso18 => {
		inputs => 18,
		depth => 15,
		title => '18-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[4,12], [5,13], [0,7], [10,17], [2,3], [14,15], [6,8], [9,11],
		[1,16], [2,6], [11,15], [1,9], [8,16], [4,10], [7,13], [3,12],
		[5,14], [0,2], [15,17], [1,4], [13,16], [0,5], [12,17], [0,1],
		[16,17], [3,7], [10,14], [6,9], [8,11], [2,15], [3,8], [9,14],
		[4,5], [12,13], [6,10], [2,6], [7,11], [1,4], [13,16], [14,15],
		[2,3], [11,15], [15,16], [1,2], [11,14], [3,6], [13,14], [3,4],
		[14,15], [2,3], [5,6], [11,12], [7,9], [8,10], [9,10], [7,8],
		[5,11], [6,12], [10,12], [5,7], [12,14], [3,5], [10,13], [4,7],
		[12,13], [4,5], [8,9], [6,9], [8,11], [9,12], [5,8], [6,7],
		[10,11], [6,8], [9,11], [7,10], [9,10], [7,8]]},
	senso19 => {
		inputs => 19,
		depth => 15,
		title => '19-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[4,10], [3,12], [0,16], [7,14], [8,11], [6,13], [15,17], [1,5],
		[9,18], [2,5], [11,16], [7,9], [1,2], [6,15], [10,12], [3,4],
		[13,17], [0,8], [14,18], [5,16], [3,7], [17,18], [1,6], [4,15],
		[0,1], [12,16], [0,3], [16,18], [2,11], [9,10], [13,14], [6,8],
		[7,13], [2,9], [11,15], [1,7], [5,10], [12,17], [8,14], [4,6],
		[10,14], [3,4], [15,16], [1,2], [14,17], [1,3], [16,17], [5,7],
		[6,13], [5,6], [10,15], [2,4], [14,15], [2,5], [11,12], [15,16],
		[2,3], [8,9], [7,13], [9,12], [8,11], [9,10], [13,14], [5,8],
		[12,14], [14,15], [3,5], [4,6], [10,13], [4,8], [4,5], [13,14],
		[7,11], [6,11], [6,9], [7,8], [11,12], [6,7], [12,13], [5,6],
		[9,10], [10,11], [11,12], [8,9], [7,8], [9,10]]},
	senso20 => {
		inputs => 20,
		depth => 14,
		title => '20-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[2,11], [8,17], [0,10], [9,19], [4,5], [14,15], [3,6], [13,16],
		[1,12], [7,18], [3,14], [5,16], [0,1], [18,19], [4,13], [6,15],
		[7,9], [10,12], [2,8], [11,17], [4,7], [12,15], [0,3], [16,19],
		[0,2], [17,19], [0,4], [15,19], [1,14], [5,18], [8,10], [9,11],
		[6,13], [5,9], [10,14], [1,3], [16,18], [6,8], [11,13], [2,7],
		[12,17], [1,5], [1,2], [14,18], [4,6], [13,15], [17,18], [15,18],
		[1,4], [3,9], [10,16], [2,3], [16,17], [13,17], [2,6], [15,17],
		[2,4], [7,8], [11,12], [5,10], [9,14], [8,12], [7,11], [3,7],
		[12,16], [3,5], [14,16], [15,16], [3,4], [5,6], [13,14], [14,15],
		[4,5], [10,11], [8,9], [11,12], [7,8], [7,10], [9,12], [5,7],
		[12,14], [9,13], [6,10], [6,7], [10,11], [12,13], [8,9], [9,11],
		[11,12], [8,10], [7,8], [9,10]]},
	sat20 => {
		inputs => 20,
		depth => 11,
		title => '20-Input Network by M. Codish, L. Cruz-Filipe, T. Ehlers, M. M�ller, P. Schneider-Kamp',
		comparators =>
		[[0,1], [2,3], [4,5], [6,7], [8,9], [10,11], [12,13], [14,15],
		[16,17], [18,19], [1,3], [5,7], [9,11], [13,15], [17,19], [0,2],
		[4,6], [8,10], [12,14], [16,18], [3,7], [9,10], [15,19], [2,6],
		[14,18], [1,5], [13,17], [0,4], [12,16], [7,19], [6,18], [5,17],
		[4,16], [3,15], [2,14], [1,13], [0,12], [2,19], [3,8], [11,16],
		[17,18], [1,4], [5,15], [9,14], [10,13], [6,12], [0,19], [1,18],
		[2,6], [7,15], [16,17], [3,4], [8,14], [5,9], [10,11], [12,13],
		[1,3], [4,5], [9,12], [13,16], [17,18], [0,15], [7,14], [8,11],
		[6,10], [0,1], [3,6], [7,13], [14,17], [18,19], [2,4], [5,10],
		[11,12], [15,16], [8,9], [2,3], [4,8], [9,11], [12,15], [16,18],
		[1,17], [5,6], [7,10], [13,14], [1,3], [4,5], [7,9], [10,11],
		[12,13], [14,15], [16,17], [18,19], [0,2], [6,8], [1,2], [3,4],
		[5,6], [7,8], [9,10], [11,12], [13,14], [15,16]]},
	senso21 => {
		inputs => 21,
		depth => 20,
		title => '21-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[5,9], [11,15], [1,19], [2,14], [6,18], [0,17], [3,20], [4,8],
		[12,16], [7,13], [1,7], [13,19], [2,11], [9,18], [4,12], [8,16],
		[3,5], [15,17], [0,10], [10,20], [0,6], [14,20], [2,3], [17,18],
		[1,4], [16,19], [0,1], [19,20], [0,2], [18,20], [7,8], [12,13],
		[9,10], [4,11], [5,6], [14,15], [10,11], [5,12], [8,15], [6,13],
		[7,14], [16,17], [1,3], [4,9], [5,7], [13,15], [11,18], [17,19],
		[1,2], [18,19], [4,5], [1,4], [15,19], [13,17], [2,7], [11,17],
		[9,14], [4,5], [15,18], [17,18], [2,4], [6,10], [8,16], [3,12],
		[10,14], [12,16], [3,8], [6,9], [14,16], [8,12], [3,6], [4,5],
		[15,16], [16,17], [3,4], [11,13], [5,7], [13,15], [6,7], [15,16],
		[4,5], [10,11], [9,11], [8,9], [11,12], [12,14], [8,10], [6,8],
		[14,15], [5,6], [12,13], [13,14], [6,8], [7,9], [10,11], [7,10],
		[7,8], [9,13], [11,12], [9,12], [9,11], [9,10]]},
	alhajbaddar22 => {
		inputs => 22,
		depth => 12,
		title => '22-Input Network by Sherenaz Waleed Al-Haj Baddar',
		comparators =>
		[[0,1], [2,3], [4,5], [6,7], [8,9], [10,11], [12,13], [14,15],
		[16,17], [18,19], [20,21], [2,4], [1,3], [0,5], [6,8], [7,9],
		[10,12], [11,13], [14,16], [15,17], [18,20], [19,21], [6,10], [7,11],
		[8,12], [9,13], [14,18], [15,19], [16,20], [17,21], [3,5], [1,4],
		[0,2], [9,17], [7,15], [11,19], [8,16], [3,12], [0,10], [1,18],
		[5,20], [13,21], [6,14], [2,4], [0,7], [17,20], [3,15], [9,18],
		[2,11], [4,16], [5,10], [1,8], [12,19], [13,14], [20,21], [0,6],
		[3,8], [12,18], [2,13], [14,16], [5,9], [10,15], [4,7], [11,17],
		[16,20], [18,19], [15,17], [12,14], [10,11], [7,9], [8,13], [4,5],
		[1,3], [2,6], [19,20], [16,17], [15,18], [11,14], [9,13], [10,12],
		[7,8], [3,5], [4,6], [1,2], [18,19], [14,16], [13,15], [11,12],
		[8,9], [5,10], [6,7], [2,3], [17,19], [16,18], [14,15], [12,13],
		[9,11], [8,10], [5,7], [3,6], [2,4], [17,18], [15,16], [13,14],
		[11,12], [9,10], [7,8], [5,6], [3,4], [16,17], [14,15], [12,13],
		[10,11], [8,9], [6,7], [4,5]]},
	senso22 => {
		inputs => 22,
		depth => 15,
		title => '22-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[10,11], [2,8], [13,19], [3,15], [6,18], [1,16], [5,20], [0,17],
		[4,21], [7,9], [12,14], [0,4], [17,21], [3,12], [9,18], [1,2],
		[19,20], [7,13], [8,14], [5,6], [15,16], [5,7], [14,16], [1,10],
		[11,20], [0,3], [18,21], [0,5], [16,21], [0,1], [20,21], [6,8],
		[13,15], [2,4], [17,19], [9,11], [10,12], [2,7], [14,19], [3,9],
		[12,18], [6,13], [8,15], [4,11], [10,17], [5,10], [11,16], [3,6],
		[15,18], [1,2], [19,20], [1,3], [18,20], [1,5], [16,20], [2,6],
		[15,19], [11,18], [2,5], [16,19], [3,10], [2,3], [18,19], [9,12],
		[4,14], [7,17], [8,13], [12,17], [4,9], [13,14], [7,8], [4,7],
		[14,17], [4,5], [16,17], [17,18], [3,4], [6,10], [11,15], [5,6],
		[15,16], [4,5], [16,17], [9,12], [8,13], [10,13], [8,11], [7,9],
		[12,14], [7,8], [13,14], [14,16], [5,7], [9,10], [11,12], [6,9],
		[12,15], [14,15], [6,7], [8,11], [10,13], [8,9], [12,13], [7,8],
		[13,14], [10,11], [11,12], [9,10]]},
	morwenn23 => {
		inputs => 23,
		depth => 18,
		title => '23-Input Network by Morwenn',
		comparators =>
		[[0, 1], [2, 3], [4, 5], [6, 7], [8, 9], [10, 11], [12, 13], [14, 15],
		[16, 17], [18, 19], [20, 21], [1, 3], [5, 7], [9, 11], [0, 2], [4, 6],
		[8, 10], [13, 15], [17, 19], [12, 14], [16, 18], [20, 22], [1, 2], [5, 6],
		[9, 10], [13, 14], [17, 18], [21, 22], [1, 5], [6, 10], [13, 17], [18, 22],
		[5, 9], [2, 6], [17, 21], [14, 18], [1, 5], [6, 10], [0, 4], [7, 11],
		[13, 17], [18, 22], [12, 16], [3, 7], [4, 8], [15, 19], [16, 20], [0, 4],
		[7, 11], [12, 16], [1, 4], [7, 10], [3, 8], [13, 16], [19, 22], [15, 20],
		[2, 3], [8, 9], [14, 15], [20, 21], [2, 4], [7, 9], [3, 5], [6, 8],
		[14, 16], [19, 21], [15, 17], [18, 20], [3, 4], [5, 6], [7, 8], [15, 16],
		[17, 18], [19, 20], [0, 12], [1, 13], [2, 14], [3, 15], [4, 16], [5, 17],
		[6, 18], [7, 19], [8, 20], [9, 21], [10, 22], [2, 12], [3, 13], [10, 20],
		[11, 21], [4, 12], [5, 13], [6, 14], [7, 15], [8, 16], [9, 17], [10, 18],
		[11, 19], [8, 12], [9, 13], [10, 14], [11, 15], [6, 8], [10, 12], [14, 16],
		[7, 9], [11, 13], [15, 17], [1, 2], [3, 4], [5, 6], [7, 8], [9, 10],
		[11, 12], [13, 14], [15, 16], [17, 18], [19, 20], [21, 22]]},
	senso23 => {
		inputs => 23,
		depth => 22,
		title => '23-Input Network via SENSO by V. K. Valsalam and R. Miikkulainen',
		comparators =>
		[[1,20], [2,21], [5,13], [9,17], [0,7], [15,22], [4,11], [6,12],
		[10,16], [8,18], [14,19], [3,8], [4,14], [11,18], [2,6], [16,20],
		[0,9], [13,22], [5,15], [7,17], [1,10], [12,21], [8,19], [17,22],
		[0,5], [20,21], [1,2], [18,19], [3,4], [21,22], [0,1], [19,22],
		[0,3], [12,13], [9,10], [6,15], [7,16], [8,11], [11,14], [4,11],
		[6,8], [14,16], [17,20], [2,5], [9,12], [10,13], [15,18], [10,11],
		[4,7], [20,21], [1,2], [7,15], [3,9], [13,19], [16,18], [8,14],
		[4,6], [18,21], [1,4], [19,21], [1,3], [9,10], [11,13], [2,6],
		[16,20], [4,9], [13,18], [19,20], [2,3], [18,20], [2,4], [5,17],
		[12,14], [8,12], [5,7], [15,17], [5,8], [14,17], [3,5], [17,19],
		[3,4], [18,19], [6,10], [11,16], [13,16], [6,9], [16,17], [5,6],
		[4,5], [7,9], [17,18], [12,15], [14,15], [8,12], [7,8], [13,15],
		[15,17], [5,7], [9,10], [10,14], [6,11], [14,16], [15,16], [6,7],
		[10,11], [9,12], [11,13], [13,14], [8,9], [7,8], [14,15], [9,10],
		[8,9], [12,14], [11,12], [12,13], [10,11], [11,12]]},
	morwenn24 => {
		inputs => 24,
		depth => 18,
		title => '24-Input Network by Morwenn',
		comparators =>
		[[0,1], [2,3], [4,5], [6,7], [8,9], [10,11], [12,13], [14,15],
		[16,17], [18,19], [20,21], [22,23], [1,3], [5,7], [9,11], [0,2],
		[4,6], [8,10], [13,15], [17,19], [21,23], [12,14], [16,18], [20,22],
		[1,2], [5,6], [9,10], [13,14], [17,18], [21,22], [1,5], [6,10],
		[13,17], [18,22], [5,9], [2,6], [17,21], [14,18], [1,5], [6,10],
		[0,4], [7,11], [13,17], [18,22], [12,16], [19,23], [3,7], [4,8],
		[15,19], [16,20], [0,4], [7,11], [12,16], [19,23], [1,4], [7,10],
		[3,8], [13,16], [19,22], [15,20], [2,3], [8,9], [14,15], [20,21],
		[2,4], [7,9], [3,5], [6,8], [14,16], [19,21], [15,17], [18,20],
		[3,4], [5,6], [7,8], [15,16], [17,18], [19,20], [0,12], [1,13],
		[2,14], [3,15], [4,16], [5,17], [6,18], [7,19], [8,20], [9,21],
		[10,22], [11,23], [2,12], [3,13], [10,20], [11,21], [4,12], [5,13],
		[6,14], [7,15], [8,16], [9,17], [10,18], [11,19], [8,12], [9,13],
		[10,14], [11,15], [6,8], [10,12], [14,16], [7,9], [11,13], [15,17],
		[1,2], [3,4], [5,6], [7,8], [9,10], [11,12], [13,14], [15,16],
		[17,18], [19,20], [21,22]]},
);

#
# The hash that will return the keys by input number.
#
my %nw_best_by_input;

#
# Set up %nw_best_by_input.
#
INIT
{
	for my $k (keys %nw_best_by_name)
	{
		my $inputs = ${$nw_best_by_name{$k}}{inputs};

		if (exists $nw_best_by_input{$inputs})
		{
			push @{$nw_best_by_input{$inputs}}, $k;
		}
		else
		{
			$nw_best_by_input{$inputs} = [$k];
		}
		#print STDERR "$inputs: " . join(", ", @{$nw_best_by_input{$inputs}}) . "\n";
	}
}

=head1 SYNOPSIS

    use Algorithm::Networksort;
    use Algorithm::Networksort::Best qw(:all);

    my $inputs = 9;

    #
    # First find if any networks exist for the size you want.
    #
    my @nwkeys = nw_best_names($inputs);

    #
    # For each sorting network, show the comparators.
    #
    for my $name (@nwkeys)
    {
        my $nw = nwsrt_best(name => $name);

        #
        # Print the list, and print the graph of the list.
        #
        print $nw->title(), "\n", $nw->formatted(), "\n\n";
        print $nw->graph_text(), "\n\n";
    }

=head1 DESCRIPTION

For some inputs, sorting networks have been discovered that are more efficient
than those generated by rote algorithms. The "Best" module allows you to use
those networks instead.

There is no guarantee that it will return the best network for
all cases. Usually "best" means that the module will return a lower number of
comparators for the number of inputs than the algorithms in Algorithm::Networksort
will return. Some will simply have a lower number of comparators, others may have
a smaller depth but an equal or greater number of comparators.

The current networks are:

=head2 9-Input Networks

=over 4

=item floyd09

A 9-input network of depth 9 discovered by R. W. Floyd.

=item senso09

A 9-input network of depth 8 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 10-Input Networks

=over 4

=item waksman10

a 10-input network of depth 9 found by A. Waksman.

=item senso10

A 10-input network of depth 8 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 11-Input Networks

=over 4

=item shapirogreen11

An 11-input network of depth 9 found by G. Shapiro and M. W. Green.

=item senso11

A 11-input network of depth 10 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 12-Input Networks

=over 4

=item shapirogreen12

A 12-input network of depth 9 found by G. Shapiro and M. W. Green.

=item senso12

A 12-input network of depth 9 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 13-Input Networks

=over 4

=item end13

A 13-input network of depth 10 generated by the END algorithm, by Hugues Juill�.

=item senso13

A 13-input network of depth 12 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 14-Input Networks

=over 4

=item green14

A 14-input network of depth 10 created by taking the 16-input network of
M. W. Green and removing inputs 15 and 16.

=item senso14

A 14-input network of depth 11 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 15-Input Networks

=over 4

=item green15

A 15-input network of depth 10 created by taking the 16-input network of
M. W. Green and removing the 16th input.

=item senso15

A 15-input network of depth 10 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 16-Input Networks

=over 4

=item green16

A 16-input network of depth 10 found by M. W. Green.

=item senso16

A 16-input network of depth 10 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 17-Input Networks

=over 4

=item senso17

A 17-input network of depth 17 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=item sat17

17-input network of depth 10 found by M. Codish, L. Cruz-Filipe, T. Ehlers,
M. M�ller, P. Schneider-Kamp.

=back

=head2 18-Input Networks

=over 4

=item alhajbaddar18

18-input network of depth 11 found by Sherenaz Waleed Al-Haj Baddar.

=item senso18

A 18-input network of depth 15 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 19-Input Networks

=over 4

=item senso19

A 19-input network of depth 15 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 20-Input Networks

=over 4

=item sat20

20-input network of depth 11 found by M. Codish, L. Cruz-Filipe, T. Ehlers, M. M�ller, P. Schneider-Kamp.

=item senso20

A 20-input network of depth 14 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 21-Input Networks

=over 4

=item senso21

A 21-input network of depth 20 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 22-Input Networks

=over 4

=item alhajbaddar22

22-input network of depth 12 found by Sherenaz Waleed Al-Haj Baddar.

=item senso22

A 22-input network of depth 15 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 23-Input Networks

=over 4

=item morwenn23

A 23-input network of depth 18 found by Morwenn, by taking the 24-input
network and removing the final input.

=item senso23

A 23-input network of depth 22 found using the SENSO program by
V. K. Valsalam and R. Miikkulaainen.

=back

=head2 24-Input Networks

=over 4

=item morwenn24

A 24-input network of depth 18 found by Morwenn
L<https://github.com/Morwenn/cpp-sort/wiki/Original-research#sorting-networks-23-and-24>.

=back

=head2 Export

None by default. There is only one available export tag, ':all', which
exports the functions to create and use sorting networks. The functions are
nwsrt_best(), nw_best_names(), and nw_best_title().

=head2 Functions

=head3 nwsrt_best

Return the Algorithm::Networksort object, given a key name. Also takes an optional
title to override the default.

    $nw = nwsrt_best(name => 'floyd09', title => "Compare depth to Bose-Nelson");

=cut

sub nwsrt_best
{
	my(%opts) = @_;

	croak "No network chosen" unless (exists $opts{name});
	my $name = $opts{name};

	croak "Unknown network name '$name'" unless (exists $nw_best_by_name{$name});
	my %nw_struct = %{ $nw_best_by_name{$name} };
	my $title = $opts{title} // $nw_struct{title};

	return Algorithm::Networksort->new(
		algorithm => 'none',
		inputs => $nw_struct{inputs},
		comparators => $nw_struct{comparators},
		depth => $nw_struct{depth},
		title => $title,
	);
}

=head3 nw_best_names

Return the list of keys for sorting networks of a giving input size.

    @names = nw_best_names(13);

=cut

sub nw_best_names
{
	my($inputs) = @_;

	return keys %nw_best_by_name unless (defined $inputs);

	unless (exists $nw_best_by_input{$inputs})
	{
		carp "No 'best' sorting networks exist for size $inputs";
		return ();
	}

	return @{$nw_best_by_input{$inputs}};
}

=head3 nw_best_title

Return a descriptive title for the network, given a key.

    $title = nw_best_title($key);

=cut

sub nw_best_title
{
	my $key = shift;
	
	unless (exists $nw_best_by_name{$key})
	{
		carp "Unknown 'best' name '$key'.";
		return "";
	}

	return $nw_best_by_name{$key}{title};
}

1;
__END__

=head1 ACKNOWLEDGMENTS

L<Doug Hoyte|https://github.com/hoytech> pointed out Sherenaz Waleed
Al-Haj Baddar's paper.

L<Morwenn|https://github.com/Morwenn> found for me the SAT and SENSO
papers, contributed 23-input and 24-input sorting networks, and caught
documentation errors.

=head1 SEE ALSO

=head2 Non-algorithmic discoveries

=over 3

=item

The networks by Floyd, Green, Shapiro, and Waksman are in
Donald E. Knuth's B<The Art of Computer Programming, Vol. 3:
Sorting and Searching> (2nd ed.), Addison Wesley Longman Publishing Co., Inc.,
Redwood City, CA, 1998.

=item

The Evolving Non-Determinism (END) algorithm by Hugues Juill� has found
more efficient sorting networks:
L<http://www.cs.brandeis.edu/~hugues/sorting_networks.html>.

=item

The 18 and 22 input networks found by Sherenaz Waleed Al-Haj Baddar
are described in her dissertation "Finding Better Sorting Networks" at
L<http://etd.ohiolink.edu/view.cgi?acc_num=kent1239814529>.

=item

The Symmetry and Evolution based Network Sort Optimization (SENSO) found more
networks for inputs of 9 through 23.

=item

Morwenn's 23 and 24-input networks are described at
L<https://github.com/Morwenn/cpp-sort/wiki/Original-research#sorting-networks-23-and-24>.

=item

Ian Parberry, "A computer assisted optimal depth lower bound for sorting
networks with nine inputs", L<http://www.eng.unt.edu/ian/pubs/snverify.pdf>.

=back

=head1 AUTHOR

John M. Gamble may be found at B<jgamble@cpan.org>

=cut

