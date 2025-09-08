-- Fix RLS Policies for Key Table
-- Run these SQL commands in your Supabase SQL Editor

-- First, let's check the current RLS status
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'Key';

-- Enable RLS on the Key table if not already enabled
ALTER TABLE "Key" ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Admins can manage keys" ON "Key";
DROP POLICY IF EXISTS "Admins can view keys" ON "Key";
DROP POLICY IF EXISTS "Admins can insert keys" ON "Key";
DROP POLICY IF EXISTS "Admins can update keys" ON "Key";
DROP POLICY IF EXISTS "Admins can delete keys" ON "Key";

-- Create comprehensive RLS policies for the Key table

-- 1. Policy for SELECT (viewing keys) - Only admins can view
CREATE POLICY "Admins can view keys" ON "Key"
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE profiles.id = auth.uid() 
        AND profiles.is_admin = true
    )
);

-- 2. Policy for INSERT (adding keys) - Only admins can add
CREATE POLICY "Admins can insert keys" ON "Key"
FOR INSERT WITH CHECK (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE profiles.id = auth.uid() 
        AND profiles.is_admin = true
    )
);

-- 3. Policy for UPDATE (modifying keys) - Only admins can update
CREATE POLICY "Admins can update keys" ON "Key"
FOR UPDATE USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE profiles.id = auth.uid() 
        AND profiles.is_admin = true
    )
) WITH CHECK (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE profiles.id = auth.uid() 
        AND profiles.is_admin = true
    )
);

-- 4. Policy for DELETE (removing keys) - Only admins can delete
CREATE POLICY "Admins can delete keys" ON "Key"
FOR DELETE USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE profiles.id = auth.uid() 
        AND profiles.is_admin = true
    )
);

-- Alternative: If you want to allow all authenticated users to manage keys
-- (Remove the above policies and use these instead)

-- DROP POLICY IF EXISTS "Admins can view keys" ON "Key";
-- DROP POLICY IF EXISTS "Admins can insert keys" ON "Key";
-- DROP POLICY IF EXISTS "Admins can update keys" ON "Key";
-- DROP POLICY IF EXISTS "Admins can delete keys" ON "Key";

-- CREATE POLICY "Authenticated users can manage keys" ON "Key"
-- FOR ALL USING (auth.role() = 'authenticated')
-- WITH CHECK (auth.role() = 'authenticated');

-- Verify the policies were created
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'Key';

-- Test the policies by checking if you can access the Key table
-- (This should work if you're logged in as an admin)
SELECT COUNT(*) FROM "Key";
