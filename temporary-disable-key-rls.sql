-- TEMPORARY: Disable RLS on Key table for testing
-- WARNING: This removes security restrictions - only use for testing!

-- Check current RLS status
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'Key';

-- Temporarily disable RLS (ONLY FOR TESTING)
ALTER TABLE "Key" DISABLE ROW LEVEL SECURITY;

-- Verify RLS is disabled
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'Key';

-- Test if you can now access the Key table
SELECT COUNT(*) FROM "Key";

-- IMPORTANT: Re-enable RLS after testing with proper policies
-- ALTER TABLE "Key" ENABLE ROW LEVEL SECURITY;
