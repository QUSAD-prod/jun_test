#ifndef FileWriter_h
#define FileWriter_h

#ifdef __cplusplus
extern "C" {
#endif

const char* writeToFile(int counter, const char* message);
const char* readFromFile();
const char* deleteFile();

#ifdef __cplusplus
}
#endif

#endif
