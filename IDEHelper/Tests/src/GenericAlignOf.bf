using System;

namespace Tests
{
	class GenericAlignOf
	{
		/// alignof of a generic parameter is an undef constant in the unspecialized pass;
		/// '~' on it folded the undef as if it were a value, producing a constant that was
		/// neither, which the cast in the mixed int32/int arithmetic then choked on
		static void Align<T>(ref int offset) where T : struct
		{
			let valueAlign = alignof(T);
			offset = (offset + valueAlign - 1) & ~(valueAlign - 1);
			offset += sizeof(T);
		}

		[Test]
		public static void TestAlignOfGeneric()
		{
			int offset = 1;
			Align<int32>(ref offset);
			Test.Assert(offset == 8);
			Align<int64>(ref offset);
			Test.Assert(offset == 16);
		}
	}
}
