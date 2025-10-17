#include "FileWriter.h"
#include <fstream>
#include <sstream>
#include <iostream>
#include <string>

using namespace std;

static string g_result;

extern "C" {
    const char* writeToFile(int counter, const char* message) {
        string filename = "counter_log.txt";
        string filepath = "/tmp/" + filename;
        
        ofstream file(filepath, ios::app);
        if (file.is_open()) {
            file << message << endl;
            file.close();
            
            ifstream readFile(filepath);
            stringstream buffer;
            buffer << readFile.rdbuf();
            readFile.close();
            
            g_result = buffer.str();
            return g_result.c_str();
        } else {
            g_result = "Ошибка записи в файл";
            return g_result.c_str();
        }
    }
    
    const char* readFromFile() {
        string filename = "counter_log.txt";
        string filepath = "/tmp/" + filename;
        
        ifstream file(filepath);
        if (file.is_open()) {
            stringstream buffer;
            buffer << file.rdbuf();
            file.close();
            g_result = buffer.str();
            return g_result.c_str();
        } else {
            g_result = "Файл не найден";
            return g_result.c_str();
        }
    }
    
    const char* deleteFile() {
        string filename = "counter_log.txt";
        string filepath = "/tmp/" + filename;
        
        if (remove(filepath.c_str()) == 0) {
            g_result = "Файл успешно удален";
            return g_result.c_str();
        } else {
            g_result = "Ошибка удаления файла";
            return g_result.c_str();
        }
    }
}
