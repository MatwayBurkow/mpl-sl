"HashTable" module
"Array" includeModule

HashTable: [
  value:;
  key:;

  {
    virtual HASH_TABLE: ();
    schema keyType: @key;
    schema valueType: @value;

    Node: [{
      key: key newVarOfTheSameType;
      keyHash: 0n32 dynamic;
      value: value newVarOfTheSameType;
    }] func;

    data: Node Array Array;
    dataSize: 0 dynamic;

    getSize: [dataSize copy] func;

    rebuild: [
      copy newBucketSize:;

      newBucketSize @data.resize
      b: 0;
      [b data.dataSize <] [
        current: b @data.at;
        i: 0;
        j: 0;
        [i current.dataSize <] [
          h: i current.at.keyHash copy;
          newB: h newBucketSize 1 - 0n32 cast and 0i32 cast;

          newB b = [
            i j = not [
              i @current.at move
              j @current.at set
            ] when
            j 1 + @j set
          ] [
            pushTo: newB @data.at;
            i @current.at move @pushTo.pushBack
          ] if

          i 1 + @i set
        ] while

        j @current.resize

        b 1 + @b set
      ] while
    ] func;

    find: [
      key:;
      keyHash: @key hash dynamic;
      [
        result: {
          success: FALSE;
          value: 0nx @valueType addressToReference;
        };

        dataSize 0 = not [
          bucketIndex: keyHash data.dataSize 1 - 0n32 cast and 0 cast;
          curBucket: bucketIndex @data.at;

          i: 0;
          [
            i curBucket.dataSize < [
              node: i @curBucket.at;
              node.key key = [
                {
                  success: TRUE;
                  value: @node.@value;
                } @result set
                FALSE
              ] [
                i 1 + @i set TRUE
              ] if
            ] &&
          ] loop
        ] when

        @result
      ] call
    ] func;

    insertUnsafe: [ # make find before please
      valueIsMoved: isMoved;
      value:;
      keyIsMoved: isMoved;
      key:;
      keyHash: key hash dynamic;

      [
        dataSize data.dataSize = [
          newBucketSize: dataSize 0 = [16][dataSize 2 *] if;
          newBucketSize rebuild
        ] when

        bucketIndex: keyHash data.dataSize 1 - 0n32 cast and 0 cast;

        newNode: {
          key: @key keyIsMoved moveIf copy;
          keyHash: key hash;
          value: @value valueIsMoved moveIf copy;
        };

        pushTo: bucketIndex @data.at;
        @newNode move @pushTo.pushBack

        dataSize 1 + @dataSize set
      ] call
    ] func;

    insert: [
      DEBUG [
        valueIsMoved: isMoved;
        value:;
        keyIsMoved: isMoved;
        key:;
        fr: key find;
        [fr.success not] "Inserting existing element!" assert
        @key keyIsMoved moveIf @value valueIsMoved moveIf insertUnsafe
      ] [
        insertUnsafe
      ] if
    ] func;

    clear: [
      @data.clear
      0 dynamic @dataSize set
    ] func;

    release: [
      @data.release
      0 dynamic @dataSize set
    ] func;

    INIT: [0 dynamic @dataSize set];

    ASSIGN: [
      other:;
      other.data     @data     set
      other.dataSize @dataSize set
    ];

    DIE: [
      #default
    ];
  }] func;

each: [b:; "HASH_TABLE" has] [
  eachInTableBody:;
  eachInTableTable:;

  eachInTableBucketIndex: 0;
  [
    eachInTableBucketIndex eachInTableTable.data.dataSize < [
      eachInTableCurrentBucket: eachInTableBucketIndex @eachInTableTable.@data.at;
      eachInTableI: 0;
      [
        eachInTableI eachInTableCurrentBucket.dataSize < [
          eachInTableNode: eachInTableI @eachInTableCurrentBucket.at;
          {key: eachInTableNode.key; value: @eachInTableNode.@value;} @eachInTableBody call
          eachInTableI 1 + @eachInTableI set TRUE
        ] &&
      ] loop

      eachInTableBucketIndex 1 + @eachInTableBucketIndex set TRUE
    ] &&
  ] loop
] pfunc;

hash: [0n8  same] [0n32 cast] pfunc;
hash: [0n16 same] [0n32 cast] pfunc;
hash: [0n32 same] [0n32 cast] pfunc;
hash: [0n64 same] [0n32 cast] pfunc;
hash: [0nx  same] [0n32 cast] pfunc;
hash: [0i8  same] [0i32 cast 0n32 cast] pfunc;
hash: [0i16 same] [0i32 cast 0n32 cast] pfunc;
hash: [0i32 same] [0i32 cast 0n32 cast] pfunc;
hash: [0i64 same] [0i32 cast 0n32 cast] pfunc;
hash: [0ix  same] [0i32 cast 0n32 cast] pfunc;