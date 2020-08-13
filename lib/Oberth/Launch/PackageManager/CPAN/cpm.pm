use Modern::Perl;
package Oberth::Launch::PackageManager::CPAN::cpm;
# ABSTRACT: App::cpm package manager

use Mu;
use Oberth::Manoeuvre::Common::Setup;

has perl_environment => (
	is => 'ro',
	required => 1,
);

has perl_install_type => (
	is => 'ro',
	required => 1,
);

method install_packages_command( :$packages = [] ) {
	$self->perl_environment->script_command(
		qw(cpm install),
		@$packages
	);
}

1;
