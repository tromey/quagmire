
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include <gnome-keyring.h>

static GnomeKeyringAttributeList *
compute_attributes (int argc, char *argv[])
{
  GnomeKeyringAttributeList *result = gnome_keyring_attribute_list_new ();
  int i;

  if (argc <= 0 || (argc % 2) != 0)
    exit (1);

  for (i = 0; i < argc; i += 2)
    gnome_keyring_attribute_list_append_string (result, argv[i], argv[i + 1]);

  return result;
}

static void
get_or_delete (int argc, char *argv[], gboolean delete)
{
  GList *flist = NULL;
  GnomeKeyringFound *found;
  GnomeKeyringAttributeList *attrs = compute_attributes (argc, argv);
  if (gnome_keyring_find_items_sync (GNOME_KEYRING_ITEM_GENERIC_SECRET,
				     attrs,
				     &flist)
      != GNOME_KEYRING_RESULT_OK)
    exit (1);
  if (flist == NULL)
    exit (delete ? 0 : 1);
  found = (GnomeKeyringFound *) flist->data;
  if (delete)
    {
      if (gnome_keyring_item_delete_sync (NULL, found->item_id)
	  != GNOME_KEYRING_RESULT_OK)
	exit (1);
    }
  else
    printf ("%s\n", found->secret);
}

/**
 * Usage:
 *    ekeyring get [ATTR VALUE]...
 *    ekeyring set [ATTR VALUE]... NAME secret
 *    ekeyring delete [ATTR VALUE]...
 */
int
main (int argc, char *argv[])
{
  GnomeKeyringAttributeList *attrs;

  g_set_application_name ("ekeyring");

  if (argc < 2)
    exit (1);

  if (! strcmp (argv[1], "get"))
    get_or_delete (argc - 2, &argv[2], FALSE);
  else if (! strcmp (argv[1], "set"))
    {
      guint32 id;
      attrs = compute_attributes (argc - 4, &argv[2]);
      if (gnome_keyring_item_create_sync (NULL,
					  GNOME_KEYRING_ITEM_GENERIC_SECRET,
					  argv[argc - 2], attrs,
					  argv[argc - 1], TRUE, &id)
	  != GNOME_KEYRING_RESULT_OK)
	exit (1);
    }
  else if (! strcmp (argv[1], "delete"))
    get_or_delete (argc - 2, &argv[2], TRUE);
  else
    exit (1);

  return 0;
}
