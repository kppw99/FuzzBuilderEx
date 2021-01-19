#include "config.h"
#include "logger.h"
#include "execgen.h"
#include "seedgen.h"
#include "opt.h"

int main(int argc, char* argv[]) {

	Logger::get()->set_level(DEBUG);

	if(!Config::get()->parse_cmd(argc, argv)) {
		Config::get()->print_usage();
		return 0;
	}

	if(Config::get()->is_exec()) {
		if(!Config::get()->parse_conf()) {
			return 0;
		}

		ExecGen::get()->generate();
	}
	else if(Config::get()->is_opt()) {
		if(!Config::get()->parse_opt_conf()) {
			return 0;
		}

		Opt::get()->opt_remove_function();
	}
	else {
		if(!Config::get()->parse_conf()) {
			return 0;
		}

		SeedGen::get()->generate();
	}

	return 0;
}
