#include "ReadFromCSV.h"

registerMooseObject("MooseApp", ReadFromCSV);

InputParameters
ReadFromCSV::validParams()
{
  InputParameters params = GeneralPostprocessor::validParams();

	 params.addRequiredParam<std::string>("csv_file", "Input csv file");


	return params;
}

ReadFromCSV::ReadFromCSV(const InputParameters & parameters)
  : GeneralPostprocessor(parameters),
	  _input_file(getParam<std::string>("csv_file"))
{
	_csv_value = 0.0;
}

void
ReadFromCSV::initialize()
{
}

void
ReadFromCSV::execute()
{
  std::ifstream ifdata;
  ifdata.open(_input_file.c_str());
  while (ifdata.good())
  {
    std::string s;
    if (!getline(ifdata, s))
      break;
    std::istringstream ss(s);
		_csv_value = atof(ss.str().c_str());
  }
  ifdata.close();
}

PostprocessorValue
ReadFromCSV::getValue()
{
  return _csv_value;
}
