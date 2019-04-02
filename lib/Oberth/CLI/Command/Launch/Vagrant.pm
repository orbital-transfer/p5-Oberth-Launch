use Oberth::Manoeuvre::Common::Setup;
package Oberth::CLI::Command::Launch::Vagrant;
# ABSTRACT: Vagrant

use Modern::Perl;
use Mu;
use CLI::Osprey;
use Clone qw(clone);
use Try::Tiny;
use Path::Tiny;

method run() {
	...
}


## no critic: 'ProhibitStringyEval'
eval q|
with qw(Oberth::CLI::Command::Role::Option::RepoPath);
|;

1;
