#pragma once

#include "GeneralPostprocessor.h"

class Function;

/**
 * This postprocessor reads a singular value from a CSV file.
 */
class ReadFromCSV : public GeneralPostprocessor
{
public:
  static InputParameters validParams();

  ReadFromCSV(const InputParameters & parameters);

  virtual void initialize() override;
  virtual void execute() override;
  virtual PostprocessorValue getValue() override;

protected:

	std::string _input_file;
  double _csv_value;

};
