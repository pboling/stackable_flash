stackable_flash
===============

Stackable Flash overrides the :[]= method of Rails' FlashHash to make it work like Array's :&lt;&lt; method instead, and makes each flash key an array.