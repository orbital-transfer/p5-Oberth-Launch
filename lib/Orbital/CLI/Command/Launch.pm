use Orbital::Transfer::Common::Setup;
package Orbital::CLI::Command::Launch;
# ABSTRACT: Launch commands

use Moo;
use CLI::Osprey;

method run() {
	require Orbital::Launch;
	Orbital::Launch->new_with_options->run;
}

subcommand 'test' => method() {
	require Orbital::Launch;
	Orbital::Launch->new_with_options->test;
};

1;
