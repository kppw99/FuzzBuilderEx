#include "opt.h"
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

Opt::Opt()
{
	//This is a constructor.
}

Opt::~Opt()
{
	//This is a destructor.
}

char* Opt::strrstr(const char* haystack, const char* needle)
{
	if (*needle == '\0')
		return (char *) haystack;

	char *result = NULL;
	for (;;) {
		char *p = (char *)strstr(haystack, needle);
		if (p == NULL)
			break;
		result = p;
		haystack = p + 1;
	}

	return result;
}

void Opt::make_optName(const char* fileName, char* tempName, char* targetName)
{
	char *token;
	char originName[256] = { 0x00, };

	strcpy(originName, fileName);
	
	token = strtok(originName, ".");
	strcpy(tempName, token);
	strcpy(targetName, token);

	strcat(tempName, "_tmp.");
	strcat(targetName, "_opt.");

	token = strtok(NULL, ".");
	strcat(tempName, token);
	strcat(targetName, token);
}

void Opt::copy_file(const char* src, const char* dest)
{
	char cmd[256] = { 0x00, };
	sprintf(cmd, "cp -rf %s %s", src, dest);
	system(cmd);
}

void Opt::remove_file(const char* fileName)
{
	char cmd[256] = { 0x00, };
	sprintf(cmd, "rm -rf %s", fileName);
	system(cmd);
}

void Opt::skip_function(const char* source, const char* target, const char* skip)
{
	int flag = 0;
	char *ptr = NULL;
	char *token = NULL;
	char temp[1024] = { 0x00, };
	char line[1024] = { 0x00, };

	FILE *r_fp = fopen(source, "r");
	FILE *w_fp = fopen(target, "w");

	while (!feof(r_fp)) {
		flag = 1;

		memset(line, 0x00, sizeof(line));
		fgets(line, sizeof(line), r_fp);
		ptr = strstr(line, skip);
		if (ptr) {
			memset(temp, 0x00, sizeof(temp));
			strcpy(temp, line);
			while (flag) {
				ptr = strstr(line, ";");
				if (ptr) {
					flag = 0;
					token = strtok(temp, "(");
					token = strtok(NULL, ";");
					ptr = strrstr(token, ")");
					if (ptr) {
						strcpy(ptr, ");\n");
					}
					memset(line, 0x00, sizeof(line));
					sprintf(line, "\t(%s", token);
					fputs(line, w_fp);
				} else {
					memset(line, 0x00, sizeof(line));
					fgets(line, sizeof(line), r_fp);
					strcat(temp, line);
					memset(line, 0x00, sizeof(line));
					strcpy(line, temp);
				}
			}
		} else {
			fputs(line, w_fp);
		}
	}

	fclose(w_fp);
	fclose(r_fp);
}

Opt* Opt::instance = nullptr;

Opt* Opt::get()
{
	if (instance == nullptr)
		instance = new Opt();
	return instance;
}

void Opt::opt_remove_function()
{
	const char *skip = NULL;
	const char *origin = NULL;
	char temp[256] = { 0x00, };
	char target[256] = { 0x00, };

	vector<string> files = Config::get()->get_files();
	vector<string> skips = Config::get()->get_skips();

	for (auto f: files) {
		origin = f.c_str();
		memset(temp, 0x00, sizeof(temp));
		memset(target, 0x00, sizeof(target));
		this->make_optName(origin, temp, target);
		this->copy_file(origin, temp);
		for (auto s: skips) {
			skip = s.c_str();
			this->skip_function(temp, target, skip);
			this->copy_file(target, temp);
		}
		this->remove_file(temp);
	}
}
