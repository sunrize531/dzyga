package org.dzyga.collections {
    public interface ISet extends ICollection, IIterable {
        /**
         * Return true if item in the set. If item is IHashable,
         * then hash will be checked, instead of strict equality.
         *
         * @param item Item to check
         * @return true if item in set. Or item with equal hash.
         */
        function has (item:*):Boolean;

        /**
         * Put all items in iterable in set.
         * @param iterable
         * @return
         */
        function update (iterable:*):Boolean;
    }
}
