=begin
WSDL4R - WSDL port definition.
Copyright (C) 2002 NAKAMURA Hiroshi.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PRATICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 675 Mass
Ave, Cambridge, MA 02139, USA.
=end


require 'wsdl/info'


module WSDL


class Port < Info
  attr_reader :name		# required
  attr_reader :binding	# required
  attr_reader :soap_address

  def initialize
    super
    @name = nil
    @binding = nil
    @soap_address = nil
  end

  def targetnamespace
    parent.targetnamespace
  end

  def porttype
    root.porttype(find_binding.type)
  end

  def find_binding
    root.binding(@binding)
  end

  def inputoperation_map
    result = {}
    find_binding.operations.each do |op_bind|
      op_name, msg_name, parts, soapaction = op_bind.inputoperation_sig
      result[op_name] = [msg_name, parts, soapaction]
    end
    result
  end

  def outputoperation_map
    result = {}
    find_binding.operations.each do |op_bind|
      op_name, msg_name, parts = op_bind.outputoperation_sig
      result[op_name] = [msg_name, parts]
    end
    result
  end

  def parse_element(element)
    case element
    when SOAPAddressName
      o = WSDL::SOAP::Address.new
      @soap_address = o
      o
    when DocumentationName
      o = Documentation.new
      o
    else
      nil
    end
  end

  def parse_attr(attr, value)
    case attr
    when NameAttrName
      @name = XSD::QName.new(targetnamespace, value)
    when BindingAttrName
      @binding = value
    else
      raise WSDLParser::UnknownAttributeError.new("Unknown attr #{ attr }.")
    end
  end
end


end
