# Key Management RLS Troubleshooting Guide

## Problem
You're getting these errors when trying to add keys:
- `406 (Not Acceptable)` - When checking if key exists
- `403 (Forbidden)` - When trying to insert new key
- `42501` - "new row violates row-level security policy for table 'Key'"

## Root Cause
Your Supabase `Key` table has Row Level Security (RLS) enabled, but there are no proper policies allowing admin users to manage keys.

## Solutions

### Option 1: Fix RLS Policies (Recommended)

1. **Open Supabase Dashboard**
   - Go to your Supabase project
   - Navigate to SQL Editor

2. **Run the RLS Fix Script**
   - Copy and paste the contents of `fix-key-rls-policies.sql`
   - Execute the script

3. **Verify Admin Status**
   - Make sure your user account has `is_admin = true` in the `profiles` table
   - Check: `SELECT * FROM profiles WHERE id = auth.uid();`

### Option 2: Temporarily Disable RLS (Testing Only)

1. **Open Supabase Dashboard**
   - Go to your Supabase project
   - Navigate to SQL Editor

2. **Run the Temporary Disable Script**
   - Copy and paste the contents of `temporary-disable-key-rls.sql`
   - Execute the script

3. **Test Key Management**
   - Try adding keys in your admin dashboard
   - If it works, the issue is RLS policies

4. **Re-enable RLS with Proper Policies**
   - After testing, run the RLS fix script
   - Then re-enable RLS: `ALTER TABLE "Key" ENABLE ROW LEVEL SECURITY;`

### Option 3: Check Your Admin Status

1. **Verify You're Logged In as Admin**
   ```sql
   SELECT id, email, is_admin FROM profiles WHERE id = auth.uid();
   ```

2. **If Not Admin, Update Your Profile**
   ```sql
   UPDATE profiles 
   SET is_admin = true 
   WHERE id = auth.uid();
   ```

## Step-by-Step Fix

### Step 1: Check Current RLS Status
```sql
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'Key';
```

### Step 2: Check Existing Policies
```sql
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'Key';
```

### Step 3: Check Your Admin Status
```sql
SELECT id, email, is_admin FROM profiles WHERE id = auth.uid();
```

### Step 4: Apply the Fix
Run the `fix-key-rls-policies.sql` script in your Supabase SQL Editor.

### Step 5: Test
Try adding a key in your admin dashboard.

## Alternative: Allow All Authenticated Users

If you want to allow all authenticated users to manage keys (less secure):

```sql
-- Drop existing policies
DROP POLICY IF EXISTS "Admins can view keys" ON "Key";
DROP POLICY IF EXISTS "Admins can insert keys" ON "Key";
DROP POLICY IF EXISTS "Admins can update keys" ON "Key";
DROP POLICY IF EXISTS "Admins can delete keys" ON "Key";

-- Create policy for all authenticated users
CREATE POLICY "Authenticated users can manage keys" ON "Key"
FOR ALL USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');
```

## Verification

After applying the fix, you should be able to:

1. ✅ View all keys in the admin dashboard
2. ✅ Add new keys through the modal
3. ✅ Toggle key status (used/available)
4. ✅ Delete keys
5. ✅ Copy keys to clipboard

## Common Issues

### Issue: Still getting 403/42501 errors
**Solution**: Make sure your user has `is_admin = true` in the profiles table.

### Issue: Can view keys but can't add them
**Solution**: The INSERT policy might not be working. Check the policy creation.

### Issue: Policies exist but still not working
**Solution**: Try dropping and recreating the policies.

## Security Note

The RLS policies ensure that only admin users can manage keys. This is important for security. Make sure to:

1. Only set `is_admin = true` for trusted users
2. Regularly audit who has admin access
3. Keep RLS enabled in production

## Need Help?

If you're still having issues:

1. Check the Supabase logs in your dashboard
2. Verify your user authentication status
3. Test with a simple SQL query first
4. Contact Supabase support if needed

---

**Remember**: Always test in a development environment first before applying changes to production!
