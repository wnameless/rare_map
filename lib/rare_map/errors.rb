module RareMap
  # RareMap::Errors defines all kinds of errors of RareMap.
  # @author Wei-Ming Wu
  module Errors
    # ConfigNotFoundError is an Exception.
    class ConfigNotFoundError < Exception ; end
    # RelationNotDefinedError is an Exception.
    class RelationNotDefinedError < Exception ; end
  end
end