# PROTZ Backend API Documentation

## Overview
PROTZ is a comprehensive service management platform that handles user management, service requests (towing and water delivery), customer vehicles, and messaging. The API follows RESTful principles and uses OpenAPI 3.1.0 specification.

## Base URL
`/api/v1`

## Authentication
Most endpoints require authentication. Admin access is required for administrative operations.

---

## Table of Contents
1. [User Management](#user-management)
2. [User Profiles](#user-profiles)
3. [Service Types](#service-types)
4. [Towing Types](#towing-types)
5. [Customer Vehicles](#customer-vehicles)
6. [Service Providers](#service-providers)
7. [Service Requests](#service-requests)
8. [Towing Requests](#towing-requests)
9. [Water Requests](#water-requests)
10. [Messages](#messages)

---

## User Management

### Register User
- **POST** `/api/v1/users/register`
- **Description**: Create a new user account (open endpoint)
- **Request Body**: `ProfileWithUserWithServiceProvider`
- **Response**: `UserPublic` (201 Created)

### User Login
- **POST** `/api/v1/users/login`
- **Description**: Login user
- **Request Body**: Form data with credentials
- **Response**: `AccessToken` (200 OK)

### Get Users
- **GET** `/api/v1/users/all`
- **Description**: Retrieve users with optional filters (Admin access required)
- **Query Parameters**:
  - `user_type`: Filter by user type
  - `is_active`: Filter by active status
  - `is_verified`: Filter by verified status
  - `limit`: Number of users to return (default: 20, max: 100)
  - `offset`: Number of users to skip (default: 0)
- **Response**: Array of `UserPublic`

### Get Current User
- **GET** `/api/v1/users/me`
- **Description**: Get current authenticated user's information
- **Response**: `ProfileWithContext`

### Update Current User
- **PATCH** `/api/v1/users/me`
- **Description**: Update current authenticated user's information
- **Request Body**: `UserUpdate`
- **Response**: `UserPublic`

### Get User by ID
- **GET** `/api/v1/users/{user_id}`
- **Description**: Retrieve a specific user by their ID (Admin access required)
- **Parameters**: `user_id` (UUID) - User identifier
- **Response**: `UserPublic`

### Update User
- **PATCH** `/api/v1/users/{user_id}`
- **Description**: Update a user's information (Admin access required)
- **Parameters**: `user_id` (UUID) - User identifier
- **Request Body**: `UserUpdate`
- **Response**: `UserPublic`

### Delete User
- **DELETE** `/api/v1/users/{user_id}`
- **Description**: Soft delete a user account (Admin access required)
- **Parameters**: `user_id` (UUID) - User identifier
- **Response**: 204 No Content

### Get User by Phone
- **GET** `/api/v1/users/search/phone/{phone_number}`
- **Description**: Retrieve a user by phone number (Admin access required)
- **Parameters**: `phone_number` (string) - User phone number
- **Response**: `UserPublic`

### Get Service Providers
- **GET** `/api/v1/users/providers`
- **Description**: Retrieve all service provider users (Admin access required)
- **Query Parameters**:
  - `is_active`: Filter by active status
  - `limit`: Number of providers to return (default: 20, max: 100)
  - `offset`: Number of providers to skip (default: 0)
- **Response**: Array of `UserPublic`

### Get Customer Users
- **GET** `/api/v1/users/customers`
- **Description**: Retrieve all customer users (Admin access required)
- **Query Parameters**:
  - `is_active`: Filter by active status
  - `limit`: Number of customers to return (default: 20, max: 100)
  - `offset`: Number of customers to skip (default: 0)
- **Response**: Array of `UserPublic`

### Get Recent Users
- **GET** `/api/v1/users/recent`
- **Description**: Retrieve recently registered users (Admin access required)
- **Query Parameters**:
  - `days`: Number of days to look back (default: 7, max: 30)
  - `limit`: Number of users to return (default: 20, max: 100)
- **Response**: Array of `UserPublic`

### Activate User
- **PATCH** `/api/v1/users/{user_id}/activate`
- **Description**: Activate a user account (Admin access required)
- **Parameters**: `user_id` (UUID) - User identifier
- **Response**: `UserPublic`

### Deactivate User
- **PATCH** `/api/v1/users/{user_id}/deactivate`
- **Description**: Deactivate a user account (Admin access required)
- **Parameters**: `user_id` (UUID) - User identifier
- **Response**: `UserPublic`

### Verify User
- **PATCH** `/api/v1/users/{user_id}/verify`
- **Description**: Mark a user as verified (Admin access required)
- **Parameters**: `user_id` (UUID) - User identifier
- **Response**: `UserPublic`

### Get User Statistics
- **GET** `/api/v1/users/stats/total`
- **Description**: Get total user count and statistics (Admin access required)
- **Response**: Statistics object

---

## User Profiles

### Create Profile
- **POST** `/api/v1/profiles/`
- **Description**: Create a new user profile
- **Request Body**: `ProfileCreate`
- **Response**: `ProfilePublic` (201 Created)

### Get Profiles
- **GET** `/api/v1/profiles/all`
- **Description**: Retrieve profiles with optional filters (Admin access required)
- **Query Parameters**:
  - `first_name`: Filter by first name
  - `last_name`: Filter by last name
  - `phone_number`: Filter by phone number
  - `city`: Filter by city
  - `state`: Filter by state
  - `limit`: Number of profiles to return (default: 20, max: 100)
  - `offset`: Number of profiles to skip (default: 0)
- **Response**: Array of `ProfilePublic`

### Get Current Profile
- **GET** `/api/v1/profiles/me`
- **Description**: Get current authenticated user's profile
- **Response**: `ProfilePublic`

### Update Current Profile
- **PATCH** `/api/v1/profiles/me`
- **Description**: Update current authenticated user's profile
- **Request Body**: `ProfileUpdate`
- **Response**: `ProfilePublic`

### Get Profile by ID
- **GET** `/api/v1/profiles/{profile_id}`
- **Description**: Retrieve a specific profile by ID
- **Parameters**: `profile_id` (UUID) - Profile identifier
- **Response**: `ProfilePublic`

### Update Profile
- **PATCH** `/api/v1/profiles/{profile_id}`
- **Description**: Update a profile (Users can only update their own profile unless admin)
- **Parameters**: `profile_id` (UUID) - Profile identifier
- **Request Body**: `ProfileUpdate`
- **Response**: `ProfilePublic`

### Delete Profile
- **DELETE** `/api/v1/profiles/{profile_id}`
- **Description**: Soft delete a profile (Admin access required)
- **Parameters**: `profile_id` (UUID) - Profile identifier
- **Response**: 204 No Content

### Get Profile by User ID
- **GET** `/api/v1/profiles/user/{user_id}`
- **Description**: Retrieve a profile by user ID (Admin access required)
- **Parameters**: `user_id` (UUID) - User identifier
- **Response**: `ProfilePublic`

### Search Profile by Phone
- **GET** `/api/v1/profiles/search/phone/{phone_number}`
- **Description**: Search for a profile by phone number (Admin access required)
- **Parameters**: `phone_number` (string) - Phone number to search
- **Response**: `ProfilePublic`

### Search Profiles by Name
- **GET** `/api/v1/profiles/search/name`
- **Description**: Search profiles by name (Admin access required)
- **Query Parameters**:
  - `query`: Search query for names (min 2 characters)
  - `limit`: Number of profiles to return (default: 20, max: 100)
- **Response**: Array of `ProfilePublic`

### Get Profiles in City
- **GET** `/api/v1/profiles/location/city/{city}`
- **Description**: Get profiles in a specific city (Admin access required)
- **Parameters**: `city` (string) - City name
- **Query Parameters**:
  - `limit`: Number of profiles to return (default: 20, max: 100)
- **Response**: Array of `ProfilePublic`

### Get Profiles in State
- **GET** `/api/v1/profiles/location/state/{state}`
- **Description**: Get profiles in a specific state (Admin access required)
- **Parameters**: `state` (string) - State name
- **Query Parameters**:
  - `limit`: Number of profiles to return (default: 20, max: 100)
- **Response**: Array of `ProfilePublic`

### Get Recent Profiles
- **GET** `/api/v1/profiles/recent`
- **Description**: Get recently created profiles (Admin access required)
- **Query Parameters**:
  - `days`: Number of days to look back (default: 7, max: 30)
  - `limit`: Number of profiles to return (default: 20, max: 100)
- **Response**: Array of `ProfilePublic`

### Get Profile Statistics
- **GET** `/api/v1/profiles/stats/total`
- **Description**: Get total profile count and location statistics (Admin access required)
- **Response**: Statistics object

---

## Service Types

### Create Service Type
- **POST** `/api/v1/service-types/`
- **Description**: Create a new service type (Admin access required)
- **Request Body**: `ServiceTypeCreate`
- **Response**: `ServiceTypePublic` (201 Created)

### Get Service Types
- **GET** `/api/v1/service-types/all`
- **Description**: Retrieve all service types with optional filters
- **Query Parameters**:
  - `code`: Filter by service code
  - `is_active`: Filter by active status
  - `limit`: Number of service types to return (default: 50, max: 100)
  - `offset`: Number of service types to skip (default: 0)
- **Response**: Array of `ServiceTypePublic`

### Get Active Service Types
- **GET** `/api/v1/service-types/active`
- **Description**: Retrieve all active service types
- **Query Parameters**:
  - `limit`: Number of service types to return (default: 50, max: 100)
- **Response**: Array of `ServiceTypePublic`

### Get Service Type by Code
- **GET** `/api/v1/service-types/code/{code}`
- **Description**: Retrieve a service type by its code
- **Parameters**: `code` (ServiceTypeCodeEnum) - Service type code
- **Response**: `ServiceTypePublic`

### Get Service Type by ID
- **GET** `/api/v1/service-types/{service_type_id}`
- **Description**: Retrieve a specific service type by ID
- **Parameters**: `service_type_id` (UUID) - Service type identifier
- **Response**: `ServiceTypePublic`

### Update Service Type
- **PATCH** `/api/v1/service-types/{service_type_id}`
- **Description**: Update a service type (Admin access required)
- **Parameters**: `service_type_id` (UUID) - Service type identifier
- **Request Body**: `ServiceTypeUpdate`
- **Response**: `ServiceTypePublic`

### Delete Service Type
- **DELETE** `/api/v1/service-types/{service_type_id}`
- **Description**: Soft delete a service type (Admin access required)
- **Parameters**: `service_type_id` (UUID) - Service type identifier
- **Response**: 204 No Content

### Get Towing Service Types
- **GET** `/api/v1/service-types/towing/types`
- **Description**: Retrieve all towing-related service types
- **Response**: Array of `ServiceTypePublic`

### Get Water Service Types
- **GET** `/api/v1/service-types/water/types`
- **Description**: Retrieve all water-related service types
- **Response**: Array of `ServiceTypePublic`

### Activate Service Type
- **PATCH** `/api/v1/service-types/{service_type_id}/activate`
- **Description**: Activate a service type (Admin access required)
- **Parameters**: `service_type_id` (UUID) - Service type identifier
- **Response**: `ServiceTypePublic`

### Deactivate Service Type
- **PATCH** `/api/v1/service-types/{service_type_id}/deactivate`
- **Description**: Deactivate a service type (Admin access required)
- **Parameters**: `service_type_id` (UUID) - Service type identifier
- **Response**: `ServiceTypePublic`

### Get Service Type Statistics
- **GET** `/api/v1/service-types/stats/total`
- **Description**: Get service type statistics (Admin access required)
- **Response**: Statistics object

---

## Towing Types

### Create Towing Type
- **POST** `/api/v1/towing-types/`
- **Description**: Create a new towing type (Admin access required)
- **Request Body**: `TowingTypeCreate`
- **Response**: `TowingTypePublic` (201 Created)

### Get Towing Types
- **GET** `/api/v1/towing-types/all`
- **Description**: Retrieve all towing types with optional filters
- **Query Parameters**:
  - `code`: Filter by towing code
  - `is_active`: Filter by active status
  - `limit`: Number of towing types to return (default: 50, max: 100)
  - `offset`: Number of towing types to skip (default: 0)
- **Response**: Array of `TowingTypePublic`

### Get Active Towing Types
- **GET** `/api/v1/towing-types/active`
- **Description**: Retrieve all active towing types
- **Query Parameters**:
  - `limit`: Number of towing types to return (default: 50, max: 100)
- **Response**: Array of `TowingTypePublic`

### Get Towing Type by Code
- **GET** `/api/v1/towing-types/code/{code}`
- **Description**: Retrieve a towing type by its code
- **Parameters**: `code` (TowingTypeCodeEnum) - Towing type code
- **Response**: `TowingTypePublic`

### Get Towing Type by ID
- **GET** `/api/v1/towing-types/{towing_type_id}`
- **Description**: Retrieve a specific towing type by ID
- **Parameters**: `towing_type_id` (UUID) - Towing type identifier
- **Response**: `TowingTypePublic`

### Update Towing Type
- **PATCH** `/api/v1/towing-types/{towing_type_id}`
- **Description**: Update a towing type (Admin access required)
- **Parameters**: `towing_type_id` (UUID) - Towing type identifier
- **Request Body**: `TowingTypeUpdate`
- **Response**: `TowingTypePublic`

### Delete Towing Type
- **DELETE** `/api/v1/towing-types/{towing_type_id}`
- **Description**: Soft delete a towing type (Admin access required)
- **Parameters**: `towing_type_id` (UUID) - Towing type identifier
- **Response**: 204 No Content

### Activate Towing Type
- **PATCH** `/api/v1/towing-types/{towing_type_id}/activate`
- **Description**: Activate a towing type (Admin access required)
- **Parameters**: `towing_type_id` (UUID) - Towing type identifier
- **Response**: `TowingTypePublic`

### Deactivate Towing Type
- **PATCH** `/api/v1/towing-types/{towing_type_id}/deactivate`
- **Description**: Deactivate a towing type (Admin access required)
- **Parameters**: `towing_type_id` (UUID) - Towing type identifier
- **Response**: `TowingTypePublic`

### Get Towing Type Statistics
- **GET** `/api/v1/towing-types/stats/total`
- **Description**: Get towing type statistics (Admin access required)
- **Response**: Statistics object

---

## Customer Vehicles

### Create Customer Vehicle
- **POST** `/api/v1/customer-vehicles/`
- **Description**: Create a new customer vehicle
- **Request Body**: `CustomerVehicleCreate`
- **Response**: `CustomerVehiclePublic` (201 Created)

### Get Customer Vehicles
- **GET** `/api/v1/customer-vehicles/all`
- **Description**: Retrieve customer vehicles with optional filters (Admin access required)
- **Query Parameters**:
  - `profile_id`: Filter by profile ID
  - `make`: Filter by vehicle make
  - `model`: Filter by vehicle model
  - `year`: Filter by vehicle year
  - `limit`: Number of vehicles to return (default: 20, max: 100)
  - `offset`: Number of vehicles to skip (default: 0)
- **Response**: Array of `CustomerVehiclePublic`

### Get My Vehicles
- **GET** `/api/v1/customer-vehicles/my-vehicles`
- **Description**: Retrieve vehicles for the current user
- **Response**: Array of `CustomerVehiclePublic`

### Get Vehicles for Profile
- **GET** `/api/v1/customer-vehicles/profile/{profile_id}`
- **Description**: Retrieve vehicles for a specific profile
- **Parameters**: `profile_id` (UUID) - Profile identifier
- **Response**: Array of `CustomerVehiclePublic`

### Get Customer Vehicle by ID
- **GET** `/api/v1/customer-vehicles/{vehicle_id}`
- **Description**: Retrieve a specific customer vehicle by ID
- **Parameters**: `vehicle_id` (UUID) - Vehicle identifier
- **Response**: `CustomerVehiclePublic`

### Update Customer Vehicle
- **PATCH** `/api/v1/customer-vehicles/{vehicle_id}`
- **Description**: Update a customer vehicle
- **Parameters**: `vehicle_id` (UUID) - Vehicle identifier
- **Request Body**: `CustomerVehicleUpdate`
- **Response**: `CustomerVehiclePublic`

### Delete Customer Vehicle
- **DELETE** `/api/v1/customer-vehicles/{vehicle_id}`
- **Description**: Soft delete a customer vehicle
- **Parameters**: `vehicle_id` (UUID) - Vehicle identifier
- **Response**: 204 No Content

### Get Vehicle by License Plate
- **GET** `/api/v1/customer-vehicles/license-plate/{license_plate}`
- **Description**: Retrieve a vehicle by license plate (Admin access required)
- **Parameters**: `license_plate` (string) - Vehicle license plate
- **Response**: `CustomerVehiclePublic`

### Get Vehicles by Make
- **GET** `/api/v1/customer-vehicles/make/{make}`
- **Description**: Retrieve vehicles by make (Admin access required)
- **Parameters**: `make` (string) - Vehicle make
- **Query Parameters**:
  - `limit`: Number of vehicles to return (default: 20, max: 100)
- **Response**: Array of `CustomerVehiclePublic`

### Get Vehicles by Make and Model
- **GET** `/api/v1/customer-vehicles/model/{make}/{model}`
- **Description**: Retrieve vehicles by make and model (Admin access required)
- **Parameters**:
  - `make` (string) - Vehicle make
  - `model` (string) - Vehicle model
- **Query Parameters**:
  - `limit`: Number of vehicles to return (default: 20, max: 100)
- **Response**: Array of `CustomerVehiclePublic`

### Get Vehicles by Year
- **GET** `/api/v1/customer-vehicles/year/{year}`
- **Description**: Retrieve vehicles by year (Admin access required)
- **Parameters**: `year` (integer) - Vehicle year
- **Query Parameters**:
  - `limit`: Number of vehicles to return (default: 20, max: 100)
- **Response**: Array of `CustomerVehiclePublic`

### Get Vehicle Statistics
- **GET** `/api/v1/customer-vehicles/stats/total`
- **Description**: Get vehicle statistics (Admin access required)
- **Response**: Statistics object

---

## Service Providers

### Get Service Providers
- **GET** `/api/v1/service-providers/all`
- **Description**: Retrieve service providers with optional filters (Admin access required)
- **Query Parameters**:
  - `service_type_id`: Filter by service type
  - `is_active`: Filter by active status
  - `is_available`: Filter by availability
  - `rating_min`: Minimum rating (0-5)
  - `city`: Filter by city
  - `state`: Filter by state
  - `limit`: Number of providers to return (default: 20, max: 100)
  - `offset`: Number of providers to skip (default: 0)
- **Response**: Array of `ServiceProviderPublic`

### Get Active Service Providers
- **GET** `/api/v1/service-providers/active`
- **Description**: Retrieve active service providers
- **Query Parameters**:
  - `service_type_id`: Filter by service type
  - `limit`: Number of providers to return (default: 20, max: 100)
- **Response**: Array of `ServiceProviderPublic`

### Get Available Service Providers
- **GET** `/api/v1/service-providers/available`
- **Description**: Retrieve available service providers
- **Query Parameters**:
  - `service_type_id`: Filter by service type
  - `limit`: Number of providers to return (default: 20, max: 100)
- **Response**: Array of `ServiceProviderPublic`

### Get My Service Provider Profile
- **GET** `/api/v1/service-providers/me`
- **Description**: Get current user's service provider profile
- **Response**: `ServiceProviderPublic`

### Update My Service Provider Profile
- **PATCH** `/api/v1/service-providers/me`
- **Description**: Update current user's service provider profile
- **Request Body**: `ServiceProviderUpdate`
- **Response**: `ServiceProviderPublic`

### Get Service Provider by ID
- **GET** `/api/v1/service-providers/{provider_id}`
- **Description**: Retrieve a specific service provider by ID
- **Parameters**: `provider_id` (UUID) - Service provider identifier
- **Response**: `ServiceProviderPublic`

### Update Service Provider
- **PATCH** `/api/v1/service-providers/{provider_id}`
- **Description**: Update a service provider (Admin or system provider access required)
- **Parameters**: `provider_id` (UUID) - Service provider identifier
- **Request Body**: `ServiceProviderUpdate`
- **Response**: `ServiceProviderPublic`

### Delete Service Provider
- **DELETE** `/api/v1/service-providers/{provider_id}`
- **Description**: Soft delete a service provider (Admin access required)
- **Parameters**: `provider_id` (UUID) - Service provider identifier
- **Response**: 204 No Content

### Get Service Provider by Profile ID
- **GET** `/api/v1/service-providers/profile/{profile_id}`
- **Description**: Retrieve a service provider by profile ID
- **Parameters**: `profile_id` (UUID) - Profile identifier
- **Response**: `ServiceProviderPublic`

### Get Providers by Service Type
- **GET** `/api/v1/service-providers/service-type/{service_type_id}`
- **Description**: Retrieve providers for a specific service type
- **Parameters**: `service_type_id` (UUID) - Service type identifier
- **Query Parameters**:
  - `is_active`: Filter by active status (default: true)
  - `is_available`: Filter by availability
  - `limit`: Number of providers to return (default: 20, max: 100)
- **Response**: Array of `ServiceProviderPublic`

### Get Top-Rated Providers
- **GET** `/api/v1/service-providers/top-rated`
- **Description**: Retrieve top-rated service providers
- **Query Parameters**:
  - `service_type_id`: Filter by service type
  - `min_rating`: Minimum rating (default: 4, range: 0-5)
  - `limit`: Number of providers to return (default: 20, max: 50)
- **Response**: Array of `ServiceProviderPublic`

### Get Providers in City
- **GET** `/api/v1/service-providers/location/city/{city}`
- **Description**: Retrieve providers in a specific city
- **Parameters**: `city` (string) - City name
- **Query Parameters**:
  - `service_type_id`: Filter by service type
  - `limit`: Number of providers to return (default: 20, max: 100)
- **Response**: Array of `ServiceProviderPublic`

### Activate Service Provider
- **PATCH** `/api/v1/service-providers/{provider_id}/activate`
- **Description**: Activate a service provider (Admin access required)
- **Parameters**: `provider_id` (UUID) - Service provider identifier
- **Response**: `ServiceProviderPublic`

### Deactivate Service Provider
- **PATCH** `/api/v1/service-providers/{provider_id}/deactivate`
- **Description**: Deactivate a service provider (Admin access required)
- **Parameters**: `provider_id` (UUID) - Service provider identifier
- **Response**: `ServiceProviderPublic`

### Toggle My Availability
- **PATCH** `/api/v1/service-providers/me/availability`
- **Description**: Toggle current user's availability status
- **Response**: `ServiceProviderPublic`

### Get Service Provider Statistics
- **GET** `/api/v1/service-providers/stats/total`
- **Description**: Get service provider statistics (Admin access required)
- **Response**: Statistics object

---

## Service Requests

### Create Service Request
- **POST** `/api/v1/service-requests/`
- **Description**: Create a new service request
- **Request Body**: `ServiceRequestCreate`
- **Response**: `ServiceRequestPublic` (201 Created)

### Get Service Requests
- **GET** `/api/v1/service-requests/all`
- **Description**: Retrieve service requests with optional filters (Admin access required)
- **Query Parameters**:
  - `profile_id`: Filter by profile ID
  - `service_type_id`: Filter by service type
  - `provider_id`: Filter by provider
  - `status`: Filter by status
  - `limit`: Number of requests to return (default: 20, max: 100)
  - `offset`: Number of requests to skip (default: 0)
- **Response**: Array of `ServiceRequestPublic`

### Get My Service Requests
- **GET** `/api/v1/service-requests/my-requests`
- **Description**: Retrieve service requests for the current user
- **Query Parameters**:
  - `status`: Filter by status
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of `ServiceRequestPublic`

### Get Requests Assigned to Me
- **GET** `/api/v1/service-requests/assigned-to-me`
- **Description**: Retrieve service requests assigned to the current service provider
- **Query Parameters**:
  - `status`: Filter by status
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of `ServiceRequestPublic`

### Get Pending Requests
- **GET** `/api/v1/service-requests/pending`
- **Description**: Retrieve pending service requests
- **Query Parameters**:
  - `service_type_id`: Filter by service type
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of `ServiceRequestPublic`

### Get Urgent Requests
- **GET** `/api/v1/service-requests/urgent`
- **Description**: Retrieve urgent service requests
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of `ServiceRequestPublic`

### Get Service Request by ID
- **GET** `/api/v1/service-requests/{request_id}`
- **Description**: Retrieve a specific service request by ID
- **Parameters**: `request_id` (UUID) - Service request identifier
- **Response**: `ServiceRequestPublic`

### Update Service Request
- **PATCH** `/api/v1/service-requests/{request_id}`
- **Description**: Update a service request
- **Parameters**: `request_id` (UUID) - Service request identifier
- **Request Body**: `ServiceRequestUpdate`
- **Response**: `ServiceRequestPublic`

### Delete Service Request
- **DELETE** `/api/v1/service-requests/{request_id}`
- **Description**: Soft delete a service request (Admin access required)
- **Parameters**: `request_id` (UUID) - Service request identifier
- **Response**: 204 No Content

### Get Request by Request Number
- **GET** `/api/v1/service-requests/request-number/{request_number}`
- **Description**: Retrieve a service request by request number
- **Parameters**: `request_number` (string) - Service request number
- **Response**: `ServiceRequestPublic`

### Assign Service Provider
- **PATCH** `/api/v1/service-requests/{request_id}/assign/{provider_id}`
- **Description**: Assign a service provider to a request (Admin or system provider access required)
- **Parameters**:
  - `request_id` (UUID) - Service request identifier
  - `provider_id` (UUID) - Service provider identifier
- **Response**: `ServiceRequestPublic`

### Update Request Status
- **PATCH** `/api/v1/service-requests/{request_id}/status/{status}`
- **Description**: Update service request status
- **Parameters**:
  - `request_id` (UUID) - Service request identifier
  - `status` (ServiceRequestStatusEnum) - New status
- **Response**: `ServiceRequestPublic`

### Cancel Service Request
- **PATCH** `/api/v1/service-requests/{request_id}/cancel`
- **Description**: Cancel a service request
- **Parameters**: `request_id` (UUID) - Service request identifier
- **Response**: `ServiceRequestPublic`

### Get Service Request Statistics
- **GET** `/api/v1/service-requests/stats/total`
- **Description**: Get service request statistics (Admin access required)
- **Response**: Statistics object

---

## Towing Requests

### Create Towing Request
- **POST** `/api/v1/towing-requests/`
- **Description**: Create a new towing request
- **Request Body**: `TowingRequestCreate`
- **Response**: `TowingRequestPublic` (201 Created)

### Get Towing Requests
- **GET** `/api/v1/towing-requests/all`
- **Description**: Retrieve towing requests with optional filters (Admin access required)
- **Query Parameters**:
  - `service_request_id`: Filter by service request
  - `vehicle_id`: Filter by vehicle
  - `towing_type_id`: Filter by towing type
  - `vehicle_condition`: Filter by vehicle condition
  - `is_emergency`: Filter by emergency status
  - `limit`: Number of requests to return (default: 20, max: 100)
  - `offset`: Number of requests to skip (default: 0)
- **Response**: Array of `TowingRequestPublic`

### Get Emergency Towing Requests
- **GET** `/api/v1/towing-requests/emergency`
- **Description**: Retrieve emergency towing requests (System provider access required)
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of objects

### Get Requests by Vehicle Condition
- **GET** `/api/v1/towing-requests/condition/{condition}`
- **Description**: Retrieve towing requests by vehicle condition
- **Parameters**: `condition` (VehicleConditionEnum) - Vehicle condition
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of objects

### Get Requests for Vehicle
- **GET** `/api/v1/towing-requests/vehicle/{vehicle_id}`
- **Description**: Retrieve towing requests for a specific vehicle
- **Parameters**: `vehicle_id` (UUID) - Vehicle identifier
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of `TowingRequestPublic`

### Get Requests by Towing Type
- **GET** `/api/v1/towing-requests/type/{towing_type_id}`
- **Description**: Retrieve towing requests by towing type
- **Parameters**: `towing_type_id` (UUID) - Towing type identifier
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of `TowingRequestPublic`

### Get Towing Request by ID
- **GET** `/api/v1/towing-requests/{towing_request_id}`
- **Description**: Retrieve a specific towing request by ID
- **Parameters**: `towing_request_id` (UUID) - Towing request identifier
- **Response**: `TowingRequestPublic`

### Update Towing Request
- **PATCH** `/api/v1/towing-requests/{towing_request_id}`
- **Description**: Update a towing request
- **Parameters**: `towing_request_id` (UUID) - Towing request identifier
- **Request Body**: `TowingRequestUpdate`
- **Response**: `TowingRequestPublic`

### Delete Towing Request
- **DELETE** `/api/v1/towing-requests/{towing_request_id}`
- **Description**: Soft delete a towing request (Admin access required)
- **Parameters**: `towing_request_id` (UUID) - Towing request identifier
- **Response**: 204 No Content

### Get Towing Request by Service Request ID
- **GET** `/api/v1/towing-requests/service-request/{service_request_id}`
- **Description**: Retrieve a towing request by service request ID
- **Parameters**: `service_request_id` (UUID) - Service request identifier
- **Response**: `TowingRequestPublic`

### Mark as Emergency
- **PATCH** `/api/v1/towing-requests/{towing_request_id}/emergency`
- **Description**: Mark a towing request as emergency (System provider access required)
- **Parameters**: `towing_request_id` (UUID) - Towing request identifier
- **Response**: `TowingRequestPublic`

### Assign Towing Type
- **PATCH** `/api/v1/towing-requests/{towing_request_id}/assign-type/{towing_type_id}`
- **Description**: Assign a towing type to the request (System provider access required)
- **Parameters**:
  - `towing_request_id` (UUID) - Towing request identifier
  - `towing_type_id` (UUID) - Towing type identifier
- **Response**: `TowingRequestPublic`

### Update Vehicle Condition
- **PATCH** `/api/v1/towing-requests/{towing_request_id}/condition/{condition}`
- **Description**: Update the vehicle condition for a towing request
- **Parameters**:
  - `towing_request_id` (UUID) - Towing request identifier
  - `condition` (VehicleConditionEnum) - Vehicle condition
- **Response**: `TowingRequestPublic`

### Get Towing Request Statistics
- **GET** `/api/v1/towing-requests/stats/total`
- **Description**: Get towing request statistics (Admin access required)
- **Response**: Statistics object

---

## Water Requests

### Create Water Request
- **POST** `/api/v1/water-requests/`
- **Description**: Create a new water request
- **Request Body**: `WaterRequestCreate`
- **Response**: `WaterRequestPublic` (201 Created)

### Get Water Requests
- **GET** `/api/v1/water-requests/all`
- **Description**: Retrieve water requests with optional filters (Admin access required)
- **Query Parameters**:
  - `service_request_id`: Filter by service request
  - `water_type`: Filter by water type
  - `delivery_method`: Filter by delivery method
  - `min_quantity`: Minimum quantity in gallons
  - `max_quantity`: Maximum quantity in gallons
  - `limit`: Number of requests to return (default: 20, max: 100)
  - `offset`: Number of requests to skip (default: 0)
- **Response**: Array of `WaterRequestPublic`

### Get Potable Water Requests
- **GET** `/api/v1/water-requests/potable`
- **Description**: Retrieve potable water requests
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of objects

### Get Non-Potable Water Requests
- **GET** `/api/v1/water-requests/non-potable`
- **Description**: Retrieve non-potable water requests
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of objects

### Get Large Water Orders
- **GET** `/api/v1/water-requests/large-orders`
- **Description**: Retrieve large water orders above specified gallons
- **Query Parameters**:
  - `min_gallons`: Minimum gallons for large orders (default: 100)
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of objects

### Get Polytank Deliveries
- **GET** `/api/v1/water-requests/polytank-deliveries`
- **Description**: Retrieve polytank delivery requests
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of `WaterRequestPublic`

### Get Direct Fill Requests
- **GET** `/api/v1/water-requests/direct-fill`
- **Description**: Retrieve direct fill requests
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of `WaterRequestPublic`

### Get Requests by Water Type
- **GET** `/api/v1/water-requests/type/{water_type}`
- **Description**: Retrieve water requests by water type
- **Parameters**: `water_type` (WaterTypeEnum) - Water type
- **Query Parameters**:
  - `limit`: Number of requests to return (default: 20, max: 100)
- **Response**: Array of objects

### Get Water Request by ID
- **GET** `/api/v1/water-requests/{water_request_id}`
- **Description**: Retrieve a specific water request by ID
- **Parameters**: `water_request_id` (UUID) - Water request identifier
- **Response**: `WaterRequestPublic`

### Update Water Request
- **PATCH** `/api/v1/water-requests/{water_request_id}`
- **Description**: Update a water request
- **Parameters**: `water_request_id` (UUID) - Water request identifier
- **Request Body**: `WaterRequestUpdate`
- **Response**: `WaterRequestPublic`

### Delete Water Request
- **DELETE** `/api/v1/water-requests/{water_request_id}`
- **Description**: Soft delete a water request (Admin access required)
- **Parameters**: `water_request_id` (UUID) - Water request identifier
- **Response**: 204 No Content

### Get Water Request by Service Request ID
- **GET** `/api/v1/water-requests/service-request/{service_request_id}`
- **Description**: Retrieve a water request by service request ID
- **Parameters**: `service_request_id` (UUID) - Service request identifier
- **Response**: `WaterRequestPublic`

### Update Water Quantity
- **PATCH** `/api/v1/water-requests/{water_request_id}/quantity/{quantity_gallons}`
- **Description**: Update the water quantity for a request
- **Parameters**:
  - `water_request_id` (UUID) - Water request identifier
  - `quantity_gallons` (integer) - New quantity in gallons (min: 1)
- **Response**: `WaterRequestPublic`

### Change Delivery Method
- **PATCH** `/api/v1/water-requests/{water_request_id}/delivery-method/{delivery_method}`
- **Description**: Change the delivery method for a water request
- **Parameters**:
  - `water_request_id` (UUID) - Water request identifier
  - `delivery_method` (DeliveryMethodEnum) - New delivery method
- **Response**: `WaterRequestPublic`

### Change Water Type
- **PATCH** `/api/v1/water-requests/{water_request_id}/water-type/{water_type}`
- **Description**: Change the water type for a request
- **Parameters**:
  - `water_request_id` (UUID) - Water request identifier
  - `water_type` (WaterTypeEnum) - New water type
- **Response**: `WaterRequestPublic`

### Get Water Request Statistics
- **GET** `/api/v1/water-requests/stats/total`
- **Description**: Get water request statistics (Admin access required)
- **Response**: Statistics object

---

## Messages

### Send Message
- **POST** `/api/v1/messages/`
- **Description**: Send a new message
- **Request Body**: `MessageCreate`
- **Response**: `MessagePublic` (201 Created)

### Get Messages
- **GET** `/api/v1/messages/all`
- **Description**: Retrieve messages with optional filters (Admin access required)
- **Query Parameters**:
  - `request_id`: Filter by service request
  - `sender_id`: Filter by sender
  - `receiver_id`: Filter by receiver
  - `message_type`: Filter by message type
  - `is_read`: Filter by read status
  - `limit`: Number of messages to return (default: 20, max: 100)
  - `offset`: Number of messages to skip (default: 0)
- **Response**: Array of `MessagePublic`

### Get My Conversations
- **GET** `/api/v1/messages/conversations`
- **Description**: Get recent conversations for the current user
- **Query Parameters**:
  - `limit`: Number of conversations to return (default: 20, max: 50)
- **Response**: Array of objects

### Get Conversation Messages
- **GET** `/api/v1/messages/conversation/{other_profile_id}`
- **Description**: Get messages in a conversation with another user
- **Parameters**: `other_profile_id` (UUID) - Other profile identifier
- **Query Parameters**:
  - `limit`: Number of messages to return (default: 50, max: 100)
- **Response**: Array of `MessagePublic`

### Get Unread Messages
- **GET** `/api/v1/messages/unread`
- **Description**: Get unread messages for the current user
- **Query Parameters**:
  - `limit`: Number of messages to return (default: 50, max: 100)
- **Response**: Array of `MessagePublic`

### Get Unread Message Count
- **GET** `/api/v1/messages/unread/count`
- **Description**: Get count of unread messages for the current user
- **Response**: Count object

### Get Sent Messages
- **GET** `/api/v1/messages/sent`
- **Description**: Get messages sent by the current user
- **Query Parameters**:
  - `limit`: Number of messages to return (default: 50, max: 100)
- **Response**: Array of `MessagePublic`

### Get Received Messages
- **GET** `/api/v1/messages/received`
- **Description**: Get messages received by the current user
- **Query Parameters**:
  - `limit`: Number of messages to return (default: 50, max: 100)
- **Response**: Array of `MessagePublic`

### Get Messages for Service Request
- **GET** `/api/v1/messages/request/{request_id}`
- **Description**: Get messages for a specific service request
- **Parameters**: `request_id` (UUID) - Service request identifier
- **Query Parameters**:
  - `limit`: Number of messages to return (default: 50, max: 100)
- **Response**: Array of `MessagePublic`

### Get Messages by Type
- **GET** `/api/v1/messages/type/{message_type}`
- **Description**: Get messages by message type (Admin access required)
- **Parameters**: `message_type` (MessageTypeEnum) - Message type
- **Query Parameters**:
  - `limit`: Number of messages to return (default: 50, max: 100)
- **Response**: Array of `MessagePublic`

### Get Message by ID
- **GET** `/api/v1/messages/{message_id}`
- **Description**: Retrieve a specific message by ID
- **Parameters**: `message_id` (UUID) - Message identifier
- **Response**: `MessagePublic`

### Update Message
- **PATCH** `/api/v1/messages/{message_id}`
- **Description**: Update a message
- **Parameters**: `message_id` (UUID) - Message identifier
- **Request Body**: `MessageUpdate`
- **Response**: `MessagePublic`

### Delete Message
- **DELETE** `/api/v1/messages/{message_id}`
- **Description**: Soft delete a message
- **Parameters**: `message_id` (UUID) - Message identifier
- **Response**: 204 No Content

### Mark Message as Read
- **PATCH** `/api/v1/messages/{message_id}/read`
- **Description**: Mark a message as read
- **Parameters**: `message_id` (UUID) - Message identifier
- **Response**: `MessagePublic`

### Mark Conversation as Read
- **PATCH** `/api/v1/messages/conversation/{other_profile_id}/read`
- **Description**: Mark all messages in a conversation as read
- **Parameters**: `other_profile_id` (UUID) - Other profile identifier
- **Response**: Status object

### Mark Messages from Sender as Read
- **PATCH** `/api/v1/messages/from/{sender_id}/read`
- **Description**: Mark all messages from a sender as read
- **Parameters**: `sender_id` (UUID) - Sender identifier
- **Response**: Status object

---

## Common Responses

### Success Responses
- **200 OK**: Successful request with response body
- **201 Created**: Resource created successfully
- **204 No Content**: Successful request with no response body

### Error Responses
- **422 Validation Error**: Request validation failed
- **Response Schema**: `HTTPValidationError`

### Pagination
Most list endpoints support pagination with:
- `limit`: Number of items per page (defaults vary, maximum typically 100)
- `offset`: Number of items to skip (default: 0)

### Authentication
- Endpoints marked as requiring "Admin access" need administrator privileges
- Endpoints marked as requiring "System provider access" need service provider privileges
- Most endpoints require user authentication

---

## Notes
- All UUID parameters must be in valid UUID format
- String parameters with minimum length requirements will be validated
- Enum parameters must use valid values from their respective enumerations
- Soft delete operations mark records as inactive rather than permanently deleting them