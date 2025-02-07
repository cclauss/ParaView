/*=========================================================================

   Program: ParaView
   Module:    $RCSfile$

   Copyright (c) 2005,2006 Sandia Corporation, Kitware Inc.
   All rights reserved.

   ParaView is a free software; you can redistribute it and/or modify it
   under the terms of the ParaView license version 1.2.

   See License_v1.2.txt for the full ParaView license.
   A copy of this license can be obtained by contacting
   Kitware Inc.
   28 Corporate Drive
   Clifton Park, NY 12065
   USA

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

========================================================================*/
#ifndef pqDoubleRangeSliderPropertyWidget_h
#define pqDoubleRangeSliderPropertyWidget_h

#include "pqApplicationComponentsModule.h"
#include "pqPropertyWidget.h"

/**
* pqDoubleRangeSliderPropertyWidget is a widget used for properties such as
* the "ThresholdRange" property on the IsoVolume filter's panel. It provides
* two double sliders, one for min and one for max and has logic to ensure that
* the min <= max.
*
* The appearance of this widget can be modified by hints in the property XML
* definition. If a hint element named "HideResetButton" is present, the range
* reset button will be hidden. If a hint element named "MinimumLabel" is present with
* a "text" attribute, that text attribute will be used as the label text instead
* of "Minimum". Similarly, the default "Maximum" label can be replaced with a
* "MaximumLabel" element with a "text" attribute.
*/
class PQAPPLICATIONCOMPONENTS_EXPORT pqDoubleRangeSliderPropertyWidget : public pqPropertyWidget
{
  Q_OBJECT
  typedef pqPropertyWidget Superclass;

public:
  pqDoubleRangeSliderPropertyWidget(
    vtkSMProxy* proxy, vtkSMProperty* property, QWidget* parent = 0);
  ~pqDoubleRangeSliderPropertyWidget() override;

  void apply() override;
  void reset() override;

protected Q_SLOTS:
  void highlightResetButton(bool highlight = true);
  void resetClicked();

private Q_SLOTS:
  /**
  * slots called when the slider(s) are moved.
  */
  void lowerChanged(double);
  void upperChanged(double);

private:
  Q_DISABLE_COPY(pqDoubleRangeSliderPropertyWidget)

  class pqInternals;
  pqInternals* Internals;
};

#endif
