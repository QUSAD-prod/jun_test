#ifndef FileWriter_h
#define FileWriter_h

#ifdef __cplusplus
extern "C" {
#endif

// C-совместимые функции для Swift
const char* writeToFile(int counter, const char* message);
const char* readFromFile();

#ifdef __cplusplus
}
#endif

#endif
