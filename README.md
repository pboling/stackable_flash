stackable_flash
===============

Stackable Flash overrides the :[]= method of Rails' FlashHash to make it work like Array's :&lt;&lt; method instead, and makes each flash key an array.

## Installation

Add this line to your application's Gemfile:

    gem 'stackable_flash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stackable_flash

## Usage

When turned on all flashes can be interacted with as arrays.

    flash[:notice] = 'First message'              # Will have the same affect that pushing it onto an array would
    flash[:notice] << 'Second message'            # No need to initialize first, or test to see if responds to :<<
    flash[:notice] |= 'Third message'             # Will add this message only if unique in the stack
    flash[:notice] += ['Fourth','Fifth']          # Will add all of the messages onto the stack individually.

    flash[:notice] # is now: ['First message','Second message','Third message','Fourth','Fifth']

But StackableFlash preserves existing functionality for code you already have written.

    flash[:notice] += ' Appended'                  # Will append a message to the top/last message on the stack.

    flash[:notice] # is now: ['First message','Second message','Third message','Fourth','Fifth Appended']

    flash[:notice] = 'Overwrite'

    flash[:notice] # is now: ['Overwrite']

It is on by default.  To turn it off:

    StackableFlash.stacked = false

To turn it back on:

    StackableFlash.stacked = true

You can even start out with it off set a flash, turn it on, and add to the stack:

    StackableFlash.stacked = false
    flash[:notice] = 'string'
    StackableFlash.stacked = true
    flash[:notice] << 'string'

There are block helpers which I am sure some enterprising individual will have a use for:

    StackableFlash.stacked({:stack_with_proc => Proc.new {|arr| arr.map! {|x| "<p>#{x}</p>"}.join } } ) do
      flash[:notice] = 'original'
      flash[:notice] << 'message'
      flash[:notice]        # => ['original','message']
      flash[:notice].stack  # => '<p>original</p><p>message</p>'
    end

And

    StackableFlash.not_stacked do
      flash[:notice] = 'original'
      flash[:notice] << ' message'
      flash[:notice]        # => 'original message'
      flash[:notice].stack  # => NoMethodError !!!
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
