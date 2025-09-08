# Key Management System - Admin Dashboard

## Overview
This key management system connects your admin dashboard to the Supabase `Key` table, providing comprehensive functionality for managing license keys for your Crown Screens application.

## Features

### 🔑 Key Management
- **View All Keys**: Display all keys from your Supabase Key table
- **Add New Keys**: Manually add keys or generate random ones
- **Toggle Status**: Mark keys as used/available
- **Delete Keys**: Remove keys from the database
- **Copy Keys**: Copy key values to clipboard
- **Export Keys**: Download all keys as CSV file

### 📊 Statistics Dashboard
- Total keys count
- Used vs Available keys
- Keys by plan (Free, Pro, Business)
- Real-time updates

### 🎯 Key Operations
- **Manual Entry**: Enter custom 16-character keys
- **Random Generation**: Generate secure random keys
- **Bulk Operations**: Add multiple keys at once
- **Status Management**: Toggle between used/available
- **Plan Assignment**: Assign keys to specific subscription plans

## Database Schema

The system works with your existing Supabase `Key` table:

```sql
CREATE TABLE "Key" (
    id SERIAL PRIMARY KEY,
    key_value VARCHAR(16) UNIQUE NOT NULL,
    plan_id INTEGER NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Plan ID Mapping
- `1` = Free Plan
- `2` = Pro Plan  
- `3` = Business Plan

## Installation

1. **Include the Key Manager Script**:
   ```html
   <script src="scripts/key-manager.js"></script>
   ```

2. **Ensure Supabase is Loaded**:
   ```html
   <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
   <script src="scripts/supabase.js"></script>
   ```

3. **Add HTML Structure** (already included in admin-dashboard.html):
   ```html
   <!-- Keys Tab -->
   <div id="keys-tab" class="tab-content">
       <!-- Key statistics, add form, and table -->
   </div>
   ```

## Usage

### Accessing Key Management
1. Open your admin dashboard
2. Click on the "🔑 Keys" tab
3. The system will automatically load all keys from your Supabase database

### Adding New Keys

#### Manual Entry
1. Enter a 16-character key in the input field
2. Select the plan (Free, Pro, or Business)
3. Click "Add Key"

#### Random Generation
1. Click "Generate Random" to create a secure random key
2. Select the plan
3. Click "Add Key"

### Managing Existing Keys

#### Toggle Status
- Click the 🔄 button to mark a used key as available
- Click the ✅ button to mark an available key as used

#### Copy Key
- Click the 📋 button to copy the key value to clipboard

#### Delete Key
- Click the 🗑️ button to delete a key (with confirmation)

### Exporting Keys
- Click "📥 Export Keys" to download all keys as a CSV file
- File includes: ID, Key Value, Plan, Status, Created Date, Updated Date

## API Reference

### KeyManager Class

#### Methods

```javascript
// Load all keys from Supabase
await keyManager.loadKeys()

// Add a new key
await keyManager.addNewKey()

// Generate a random key value
keyManager.generateRandomKey()

// Toggle key status
await keyManager.toggleKeyStatus(keyId, currentStatus)

// Delete a key
await keyManager.deleteKey(keyId)

// Copy key to clipboard
await keyManager.copyKey(keyValue)

// Export keys to CSV
await keyManager.exportKeys()

// Get key statistics
const stats = keyManager.getKeyStatistics()
```

#### Statistics Object
```javascript
{
    total: 100,        // Total number of keys
    used: 45,          // Number of used keys
    available: 55,     // Number of available keys
    free: 30,          // Number of free plan keys
    pro: 40,           // Number of pro plan keys
    business: 30       // Number of business plan keys
}
```

## Configuration

### Supabase Setup
Ensure your Supabase project has the following:

1. **Key Table**: The `Key` table with the schema above
2. **RLS Policies**: Proper Row Level Security policies for admin access
3. **Service Role Key**: For admin operations

### RLS Policy Example
```sql
-- Allow admins to manage keys
CREATE POLICY "Admins can manage keys" ON "Key"
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE profiles.id = auth.uid() 
        AND profiles.is_admin = true
    )
);
```

## Testing

Use the included `test-keys.html` file to test the key management functionality:

1. Open `test-keys.html` in your browser
2. Test Supabase connection
3. Test loading keys
4. Test adding keys
5. Test statistics
6. Test export functionality

## Error Handling

The system includes comprehensive error handling:

- **Connection Errors**: Shows notification if Supabase is unavailable
- **Validation Errors**: Validates key format (16 characters)
- **Duplicate Keys**: Prevents adding duplicate key values
- **Permission Errors**: Handles RLS policy violations
- **Network Errors**: Graceful handling of network issues

## Notifications

The system provides user-friendly notifications for:
- ✅ Success operations
- ❌ Error messages
- ℹ️ Information updates
- ⚠️ Warnings

## Security Features

- **Input Validation**: Ensures keys are exactly 16 characters
- **Duplicate Prevention**: Checks for existing keys before adding
- **Admin Access**: Requires admin privileges for key management
- **Secure Generation**: Uses cryptographically secure random generation

## Integration with Existing System

The key management system integrates seamlessly with:

- **Key Delivery Service**: Uses the same Key table for license distribution
- **Subscription System**: Links keys to subscription plans
- **Admin Dashboard**: Part of the main admin interface
- **User Management**: Tracks key usage by users

## Troubleshooting

### Common Issues

1. **Keys not loading**: Check Supabase connection and RLS policies
2. **Cannot add keys**: Verify admin permissions and key format
3. **Export not working**: Check browser download permissions
4. **Statistics not updating**: Ensure keys are loaded first

### Debug Mode
Enable console logging to see detailed operation information:
```javascript
console.log('Key Manager Debug Mode');
```

## Future Enhancements

Potential improvements:
- Bulk key generation
- Key usage analytics
- Automated key expiration
- Key validation rules
- Integration with payment systems
- Key transfer between users

## Support

For issues or questions:
1. Check the browser console for error messages
2. Verify Supabase connection and permissions
3. Test with the included test page
4. Review the RLS policies

---

**Note**: This system is designed to work with your existing Supabase Key table structure. Make sure your database schema matches the expected format for optimal functionality.
