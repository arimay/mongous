require "mongous/version"
require "mongous/base"
require "mongous/extention"
require "mongous/filter"
require "mongous/document"

module Mongous
  class  <<  self
    include Mongous::Base
  end
end
