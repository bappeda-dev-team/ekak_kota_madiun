# for generating unique code

class KodeService
  def initialize(*args)
    @args = args
  end

  def call
    @args.join('_')
  end
end
