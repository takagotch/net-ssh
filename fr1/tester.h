#ifndef DLIB_TESTEr_
#define DLIB_TESTEr_

#include <iostream>
#include <string>
#include <dlib/map.h>
#include <dlib/logger.h>
#include <dlib/assert.h>
#include <dlib/algs.h>
#include <typeinfo>

#ifdef __INTEL_COMPILER
#pragma warning (disable: 654)
#endif

#define DLIB_TEST(_exp) check_test(bool(_exp), __LINE__, __FILE__, #_exp)

#define DLIB_TEST_MSG(_exp, _message)
  do {increment_test_count(); if ( !(_exp) )
  {
    std::ostringstream dlib_o_out;
    dlib_o_out << "" << __LINE__ << "";
    dlib_o_out << "" << __FILE__ << "";
    dlib_o_out << "" << #_exp << "";
    dlib_o_out << _message << "\n";
    throw dlib::error(dlib_o_out.str());
  }}while(0)

namespace test
{
  class tester;
  typedef dlib::map<std::string,tester*>::kernel_1a_c map_of_testers;

  map_of_testers& testers (
  );

  void check_test (
    bool _exp,
    long line,
    const char* file,
    const char* _exp_str
  );

  extern bool be_verbose;

  dlib::uint64 number_of_testing_statements_executed (		  
  );

  void increment_test_count (
  );

  void print_spinner (
  );

  class tester
  {
    
  public:
    tester (
      const std::string switch_name,
      const std::string description_,
      unsigned long num_of_args = 0
    );

    virtual ~tester (
    ){}

    const std::string& cmd_line_switch (
    ) const;

    const std::string& description (
    ) const;

    virtual void perform_test (
    );

    virtual void perform_test (
      const std::string& arg
    );

    virtual void perform_test (
      const std::string& arg1,
      const std::string& arg2
    );

  private:

    const std::string switch_name;
    const std::string description_;
    const unsigned long num_of_args_;
  };
}

#endif

