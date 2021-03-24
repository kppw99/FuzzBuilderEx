#include "logger.h"

#include <string>
#include <vector>

using namespace std;

class Opt {
    private:
        Opt();
        ~Opt();

		static Opt* instance;

		char* strrstr(const char* haystack, const char* needle);
		void make_optName(const char* fileName, char* tempName, char* targetName);
		void copy_file(const char* src, const char* dest);
		void remove_file(const char* fileName);
		void skip_function(const char* source, const char* target, const char* skip);

    public:
		static Opt* get();

		void opt_remove_function();
};
