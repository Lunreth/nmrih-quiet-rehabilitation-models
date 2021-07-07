#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

bool g_bEnabled;
int eliteModel;

public Plugin myinfo =
{
	name = "[NMRiH] NMO_Quiet_Rehabilitation_x Models",
	author = "Ulreth",
	description = "Custom models for nmo_quiet_rehabilitation",
	version = "2.1",
	url = "https://steamcommunity.com/groups/lunreth-laboratory"
};

public void OnMapStart()
{
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, sizeof(map));

	if(StrContains(map, "nmo_quiet_rehabilitation") != -1)
    {
        eliteModel = PrecacheModel("models/nmr_zombie/fast_zombie.mdl", true);
        g_bEnabled = true;
    }
    else
    {
        g_bEnabled = false;
    }
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if(!g_bEnabled)
        return;
	if(StrEqual(classname, "npc_nmrih_runnerzombie"))
		SDKHook(entity, SDKHook_SpawnPost, OnRunnerSpawned);
}

public void OnRunnerSpawned(int zombie)
{
	char targetname[64];
	GetEntPropString(zombie, Prop_Send, "m_iName", targetname, sizeof(targetname));

	if(StrEqual(targetname, "prison_soldierbackup_rappel"))
	{
		CreateTimer(2.0, Timer_RunnerSpawned, EntIndexToEntRef(zombie));
	}
}

public Action Timer_RunnerSpawned(Handle timer, int ref_zombie)
{
	int zombie_index = EntRefToEntIndex(ref_zombie);
	if (zombie_index > 0)
	{
		if(IsValidEntity(zombie_index))
		{
			SetEntProp(zombie_index, Prop_Send, "m_nModelIndex", eliteModel);
			SetEntityModel(zombie_index, "models/nmr_zombie/fast_zombie.mdl");
		}
	}
}