#include <iomanip>
#include <iostream>
#include <thread>
#include "dca.h"
#include "utils.h"

int main(int argc, char *argv[])
{
    if(argc < 5)
    {
        std::cerr << "Usage: " << argv[0] << " <trace_file> <guess_file> <num_traces> <correct_key>\n";
        return 1;
    }

    dca::config_t conf;
    conf.trace_values = dca::utils::load_file(argv[1]);
    conf.guess_values = dca::utils::load_file(argv[2]);
    conf.traces = std::atoi(argv[3]);
    conf.samples_per_trace = conf.trace_values.size() / conf.traces;
    conf.sample_start = 0;
    conf.sample_end = conf.samples_per_trace;
    int correct_key = std::strtoul(argv[4], NULL, 16);
    dca::extract_key_byte(0, conf, correct_key);
    return 0;
}

